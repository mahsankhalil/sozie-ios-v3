//
//  MyUploadsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
import CropViewController

public enum PostFilterType: Int {
    case success
    case inReview
    case redo
}
class MyUploadsVC: UIViewController {

    @IBOutlet weak var addMesurementButton: DZGradientButton!
    @IBOutlet weak var addMeasurementView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var inReviewButton: UIButton!
    @IBOutlet weak var reDoButton: UIButton!
    @IBOutlet weak var successCountLabel: UILabel!
    @IBOutlet weak var inReviewCountLabel: UILabel!
    @IBOutlet weak var redoCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currentFilterType: PostFilterType?
    var reuseableIdentifier = "MyUploadsCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var serverParams = [String: Any]()
    var nextURL: String?
    var viewModels: [UserPostWithUploadsViewModel] = []
    var currentPost: UserPost?
    var currentTaskId: String?
    var currentCollectionViewIndex: Int?
    var currentCellIndex: Int?
    var posts: [UserPost] = [] {
        didSet {
            viewModels.removeAll()
            for post in posts {
                let viewModel = UserPostWithUploadsViewModel(uploads: post.uploads, isTutorial: post.isTutorialPost, isApproved: post.isApproved, isModerated: post.isModerated, productURL: post.currentProduct?.imageURL ?? "", postType: currentFilterType ?? .success, videos: post.videos)
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
            if UserDefaultManager.checkIfMeasurementEmpty() {
                noDataLabel.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addMesurementButton.shadowAdded = false
        self.addMesurementButton.shadowLayer = nil
        currentFilterType = .inReview
        self.tableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        reloadData()
        if let sozieType = UserDefaultManager.getCurrentSozieType(), sozieType == "BS" {
            noDataLabel.text = "Upload pictures to create your gallery"
        } else {
            noDataLabel.text = "Upload pictures to create your gallery and earn money!"
        }
    }
    func reloadData() {
        switch currentFilterType {
        case .success:
            setupButtonSelected(button: successButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: reDoButton)
//            hideOtherLabels(label: successCountLabel)
        case .inReview:
            setupButtonSelected(button: inReviewButton)
            setUpButtonUnselected(button: successButton)
            setUpButtonUnselected(button: reDoButton)
//            hideOtherLabels(label: inReviewCountLabel)
        case .redo:
            setupButtonSelected(button: reDoButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: successButton)
//            hideOtherLabels(label: redoCountLabel)
        default:
            setupButtonSelected(button: successButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: reDoButton)
//            hideOtherLabels(label: successCountLabel)
        }
    }
    func setUpButtonUnselected(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hex: "0ABAB5").cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(hex: "898989"), for: .normal)
    }
    func setupButtonSelected(button: UIButton) {
        button.backgroundColor = UIColor(hex: "0ABAB5")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDataAndFetch()
        hideShowAddMeasurementView()
        self.addMesurementButton.removeShadow()
    }
    func hideShowAddMeasurementView() {
        if UserDefaultManager.checkIfMeasurementEmpty() && self.posts.count > 0 {
            if self.posts[0].isTutorialPost == false {
                self.addMeasurementView.isHidden = false
            } else {
                self.addMeasurementView.isHidden = true
            }
        } else {
            self.addMeasurementView.isHidden = true
        }
    }
    func resetDataAndFetch() {
        serverParams.removeAll()
        posts.removeAll()
        serverParams["review_action"] = "P"
        currentFilterType = .inReview
        getPostsFromServer()
        self.getPostsCount()
        reloadData()
    }
    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            getPostsFromServer()
        } else {
            serverParams.removeValue(forKey: "next")
            self.tableView.bottomRefreshControl?.endRefreshing()
        }
    }
    func getPostsFromServer() {
        serverParams["user_id"] = UserDefaultManager.getCurrentUserId()
        ServerManager.sharedInstance.getUserPosts(params: serverParams) { (isSuccess, response) in
            if isSuccess {
                let paginatedData = response as! PostPaginatedResponse
                self.posts.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
//                self.applyCountLabel(count: paginatedData.count)
                self.hideShowAddMeasurementView()
                self.tableView.bottomRefreshControl?.endRefreshing()
//                self.countLabel.text = String(paginatedData.count) + ( paginatedData.count <= 1 ? " Upload" : " Uploads")
            }
        }
    }
    func getPostsCount() {
        var dataDict = [String: Any]()
        dataDict["user_id"] = UserDefaultManager.getCurrentUserId()
        ServerManager.sharedInstance.getUserPostsCount(params: dataDict) { (isSuccess, response) in
            if isSuccess {
                let countData = response as! PostCountResponse
                self.successCountLabel.text = String(countData.approveCount)
                self.inReviewCountLabel.text = String(countData.pendingCount)
                self.redoCountLabel.text = String(countData.rejectedCount)

            }
        }

    }
//    func applyCountLabel(count: Int) {
//        switch currentFilterType {
//        case .success:
//            self.successCountLabel.text = String(count)
//        case .inReview:
//            self.inReviewCountLabel.text = String(count)
//        case .redo:
//            self.redoCountLabel.text = String(count)
//        default:
//            return
//        }
//    }
    func resetData() {
        serverParams.removeAll()
        posts.removeAll()
//        redoCountLabel.text = ""
//        inReviewCountLabel.text = ""
//        successCountLabel.text = ""
    }
//    func hideOtherLabels(label: UILabel) {
//        label.isHidden = false
//        if label == successCountLabel {
//            inReviewCountLabel.isHidden = true
//            redoCountLabel.isHidden = true
//        } else if label == inReviewCountLabel {
//            successCountLabel.isHidden = true
//            redoCountLabel.isHidden = true
//        } else if label == redoCountLabel {
//            successCountLabel.isHidden = true
//            inReviewCountLabel.isHidden = true
//        }
//    }

    @IBAction func addMeasurementButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let measurementVC = storyBoard.instantiateViewController(withIdentifier: "MeasurementsVC") as! MeasurementsVC
        self.tabBarController?.navigationController?.pushViewController(measurementVC, animated: true)
    }
    @IBAction func successButtonTapped(_ sender: Any) {
        currentFilterType = .success
        reloadData()
        resetData()
        serverParams["review_action"] = "A"
        getPostsFromServer()
    }
    @IBAction func inReviewButtonTapped(_ sender: Any) {
        currentFilterType = .inReview
        reloadData()
        resetData()
        serverParams["review_action"] = "P"
        getPostsFromServer()
    }
    @IBAction func redoButtonTapped(_ sender: Any) {
        currentFilterType = .redo
        reloadData()
        resetData()
        serverParams["review_action"] = "R"
        getPostsFromServer()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toProductDetail" {
//            let destVC = segue.destination as? ProductDetailVC
//            destVC?.currentProduct = currentPost?.product
//            destVC?.currentPostId = currentPost?.postId
        }
    }
}

extension MyUploadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        let identifier = reuseableIdentifier
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if tableViewCell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? MyUploadsCell {
            currentCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        if viewModel.isTutorial {
            return 220
        }
        return 250.0
    }
}
extension MyUploadsVC: MyUploadsCellDelegate {
    func editButtonTapped(button: UIButton) {
        let currentPost = posts[button.tag]
        let addPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostAndFitTipsVC") as! UploadPostAndFitTipsVC
        addPostVC.currentPostId = currentPost.postId
        addPostVC.currentProduct = currentPost.currentProduct
        addPostVC.delegate = self
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            profileParentVC.navigationController?.pushViewController(addPostVC, animated: true)
        }
    }
    func warningButtonTapped(button: UIButton) {
        let popUpInstnc = RejectionReasonPopupWithoutTitle.instance()
        popUpInstnc.delegate = self
        popUpInstnc.postIndex = button.tag
        let popUpVC = PopupController
             .create(self.tabBarController?.navigationController ?? self)
             .show(popUpInstnc)
         _ = popUpVC.didCloseHandler { (_) in
        }
        popUpInstnc.closeHandler = { []  in
         popUpVC.dismiss()
        }
    }
    func imageTapped(collectionViewTag: Int, cellTag: Int) {
        if currentFilterType == .redo || currentFilterType == .inReview {
            if cellTag != 0 {
                var reason = ""
                // Video will be always at the end
                if cellTag <= posts[collectionViewTag].uploads.count {
                    reason = posts[collectionViewTag].uploads[cellTag - 1].rejectionReason ?? ""
                } else if let videos = posts[collectionViewTag].videos, videos.count > 0 {
                    reason = videos[0].rejectionReason ?? ""
                }
                if reason == "" {
                    return
                }
            let popUpInstnc = RejectionReasonPopup.instance(reason: reason, collectionViewTag: collectionViewTag, cellTag: cellTag)
                popUpInstnc.delegate = self
                let popUpVC = PopupController
                    .create(self.tabBarController?.navigationController ?? self)
                     .show(popUpInstnc)
                 _ = popUpVC.didCloseHandler { (_) in
                 }
                popUpInstnc.closeHandler = {
                    popUpVC.dismiss()
                }
            }
        }
    }
    func updatePostData(image: UIImage?, videoURL: URL? = nil) {
        var dataDict = [String: Any]()
        if let postIndex = currentCollectionViewIndex, let uploadIndex = currentCellIndex {
            if uploadIndex <= posts[postIndex].uploads.count {
                let uploadId = posts[postIndex].uploads[uploadIndex - 1 ].uploadId
                if image != nil {
                    dataDict["existing_images_ids"] = uploadId
                }
            } else {
                if videoURL != nil {
                    if let videos = posts[postIndex].videos {
                        let videoPostID = videos[0].uploadId
                        dataDict["video_to_edit_id"] = videoPostID
                    }
                }
            }
            let postId = posts[postIndex].postId
            var imagesData: [Data] = []
            if let imageData = image?.jpegData(compressionQuality: 1.0) {
                imagesData.append(imageData)
            }
            SVProgressHUD.show()
            ServerManager.sharedInstance.editPostWithMultipleImages(params: dataDict, postId: postId, imagesToEdit: imagesData, imagesToUploads: nil, videoURL: videoURL) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.currentTaskId = (response as! AddPostResponse).taskInfo.taskId
                    self.getPostProgress(isTutorial: false)
                }
            }
        }
    }
    func getPostProgress(isTutorial: Bool) {
        if let taskId = self.currentTaskId {
            ServerManager.sharedInstance.getPostProgress(taskId: taskId) { (isSuccess, response) in
                if isSuccess {
                    let taskInfo = (response as! ProgressResponse).taskInfo
                    if taskInfo.taskStatus == "SUCCESS" || taskInfo.taskStatus == "NOTREQUIRED" {
                        SVProgressHUD.dismiss()
                        self.resetDataAndFetch()
                    } else if taskInfo.taskStatus == "FAILURE" {
                        SVProgressHUD.dismiss()
                    } else {
                        SVProgressHUD.showProgress(Float( taskInfo.info.progress.percent) / 100.0)
                        self.getPostProgress(isTutorial: isTutorial)
                    }
                }
            }
        }
    }
}
extension MyUploadsVC: RejectionResponseWithoutTitleDelegate {
    func rejectionResponseWithoutTitleTryAgainButtonTapped(button: UIButton) {
//        let currentPost = posts[button.tag]
//        let addPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostAndFitTipsVC") as! UploadPostAndFitTipsVC
//        addPostVC.currentPostId = currentPost.postId
//        addPostVC.currentProduct = currentPost.currentProduct
//        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
//            profileParentVC.navigationController?.pushViewController(addPostVC, animated: true)
//        }
    }
}
extension MyUploadsVC: RejectionResponseDelegate {
    func tryAgainButtonTapped(button: UIButton, collectionViewTag: Int?, cellTag: Int?) {
        currentCollectionViewIndex = collectionViewTag
        currentCellIndex = cellTag
        if let currentCelltag = cellTag, let currentColectionViewTag = collectionViewTag {
            if currentCelltag > posts[currentColectionViewTag].uploads.count {
                // its video and we have to show video controller
                let videoPicker = self.storyboard?.instantiateViewController(withIdentifier: "VideoPickerVC") as! VideoPickerVC
                videoPicker.modalPresentationStyle = .fullScreen
                videoPicker.delegate = self
                self.present(videoPicker, animated: true, completion: nil)
                return
            }
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            UtilityManager.openCustomCameraFrom(viewController: self, photoIndex: (cellTag ?? 1) - 1, progressTutorialVC: nil)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.showPosePopup(index: (cellTag ?? 1) - 1)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showPosePopup(index: Int?) {
        let popUpInstnc = PosePopupVC.instance(photoIndex: index)
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc)
        let options = PopupCustomOption.layout(.top)
        _ = popUpVC.customize([options])
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
            UtilityManager.openGalleryFrom(viewController: self)
        }
    }

}
extension MyUploadsVC: CustomVideoRecorderDelegate {
    func customImagePickerController(_ picker: VideoPickerVC, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let videoURL = info["UIImagePickerControllerMediaURL"] as? URL {
            self.updatePostData(image: nil, videoURL: videoURL)
        }
    }
}
extension MyUploadsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showCropVC(image: pickedImage)
        }
    }
    func showCropVC(image: UIImage) {
        let cropVC = CropViewController(image: image)
        cropVC.delegate = self
//        cropVC.customAspectRatio = CGSize(width: 9.0, height: 16.0)
        cropVC.customAspectRatio = CGSize(width: 4.0, height: 5.0)
        cropVC.aspectRatioPickerButtonHidden = true
        cropVC.aspectRatioLockEnabled = true
        cropVC.resetButtonHidden = true
        cropVC.rotateButtonsHidden = true
        cropVC.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.toolbar.cancelTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.cropView.gridOverlayHidden = true
        cropVC.cropView.setGridOverlayHidden(true, animated: true)
        let imgVu = UIImageView(image: UIImage(named: "Canvas-Gallery"))
        imgVu.center = cropVC.cropView.center
        imgVu.frame = cropVC.cropView.cropBoxFrame
        imgVu.contentMode = .center
        cropVC.cropView.addSubview(imgVu)
        self.present(cropVC, animated: true) {
            imgVu.frame = cropVC.cropView.cropBoxFrame
        }
    }
    func setupImage(pickedImage: UIImage) {
        let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 1080, height: (pickedImage.size.height/pickedImage.size.width)*1080))
        self.updatePostData(image: scaledImg)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            UtilityManager.showMessageWith(title: "Save Error", body: error.localizedDescription, in: self)
        }
    }
}
extension MyUploadsVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.setupImage(pickedImage: image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
extension MyUploadsVC: CaptureManagerDelegate {
    func processCapturedImage(image: UIImage) {
        let scaledImg = image.scaleImageToSize(newSize: CGSize(width: 1080, height: (image.size.height/image.size.width)*1080))
        self.updatePostData(image: scaledImg)
    }
}
extension MyUploadsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSizeCollectionViewCell", for: indexPath)
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth: Int = Int(UIScreen.main.bounds.size.width - 6 )
        let widthPerItem = Double(availableWidth/3)
        return CGSize(width: widthPerItem, height: widthPerItem )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPost = posts[indexPath.row]
        self.performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
extension MyUploadsVC: UploadPostAndFitTipsDelegate {
    func uploadPostInfoButtonTapped() {
//        if let tutVC = tutorialVC {
//            tutVC.view.removeFromSuperview()
//        }
//        instructionsScrollView.isHidden = false
//        disableRootButtons()
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            if let tabVC = profileParentVC.tabViewController {
                if let requestVC = tabVC.sozieRequestsVC {
                    tabVC.displayControllerWithIndex(0, direction: .reverse, animated: false)
                    requestVC.uploadPostInfoButtonTapped()
                }
            }
        }
    }
}
