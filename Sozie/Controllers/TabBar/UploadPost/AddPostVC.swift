//
//  AddPostVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 11/26/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SVProgressHUD
import AVKit
import CropViewController
import MBProgressHUD
class AddPostVC: UIViewController {
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var postDeleteButton: UIButton!
    @IBOutlet weak var videoDeleteButton: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var submitButton: UIButton!
    var currentRequest: SozieRequest?
    var currentProduct: Product?
    weak var delegate: UploadPostAndFitTipsDelegate?
//    var selectedIndex: Int?
    var currentVideoURL: URL?
    var currentPostId: Int?
    var currentPost: UserPost?
    var currentTaskId: String?
    var pictureSelectedIndex: Int?
    var videoSelectedIndex: Int?
    var pictureViewModels = [UploadPictureViewModel(title: "Look 1", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "Look 2", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "More Looks", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false)]
    var videoViewModels = [UploadPictureViewModel(title: "Take 1", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true), UploadPictureViewModel(title: "Take 2", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true), UploadPictureViewModel(title: "More Takes", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true)]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if currentProduct == nil {
            currentProduct = currentRequest?.requestedProduct
            fetchProductDetailFromServer()
        } else {
            populateProductData()
        }
        self.postImageView.layer.borderWidth = 1.0
        self.postImageView.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
        self.videoImageView.layer.borderWidth = 1.0
        self.videoImageView.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
        if let postID = currentPostId {
            self.getCurrentPost(postId: postID)
            self.postDeleteButton.isHidden = true
        }
    }
    func getCurrentPost(postId: Int) {
        ServerManager.sharedInstance.getCurrentPostWith(postID: postId) { (isSuccess, response) in
            if isSuccess {
                let currentPost = response as! UserPost
                self.currentPost = currentPost
                self.populateDataWithCurrentPost()
            }
        }
    }
    func populateDataWithCurrentPost() {
        pictureViewModels.removeAll()
        videoViewModels.removeAll()
        if let post = currentPost {
            var index = 0
            var videoIndex = 0
            for upload in post.uploads {
                let title = "Look " + String(index + 1)
                let viewModel = UploadPictureViewModel(title: title, attributedTitle: nil, imageURL: URL(string: upload.imageURL), image: nil)
                index = index + 1
                pictureViewModels.append(viewModel)
            }
            for video in post.videos ?? [] {
                let viewModel = UploadPictureViewModel(title: "Take " + String(videoIndex + 1), attributedTitle: nil, imageURL: nil, image: nil, isVideo: true, videoURL: video.videoURL)
                videoViewModels.append(viewModel)
                videoIndex = videoIndex + 1
            }
            if index < 6 {
                let optionalViewModel = UploadPictureViewModel(title: "More Looks", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                pictureViewModels.append(optionalViewModel)
            }
            if videoIndex < 6 {
                let optionalViewModel = UploadPictureViewModel(title: "More Takes", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true)
                videoViewModels.append(optionalViewModel)
            }
            self.postImageView.sd_setImage(with: URL(string: post.uploads[0].imageURL), completed: nil)
            if let videos = post.videos {
                if videos.count > 0 {
                    UtilityManager.getThumbnailImageFromVideoUrl(url: URL(string: videos[0].videoURL)!) { (image) in
                        self.videoImageView.image = image
                    }
                }
            }
            if let video = post.videos?[0] {
                UtilityManager.getThumbnailImageFromVideoUrl(url: URL(string: video.videoURL)!) { (image) in
                    self.videoImageView.image = image
                }
            }
            self.imagesCollectionView.reloadData()
            self.videosCollectionView.reloadData()
        }
    }
    func checkIfAllImagesAndVideoUploaded() -> Bool {
        for index in 0...pictureViewModels.count where index < 2 && pictureViewModels[index].image == nil && pictureViewModels[index].imageURL == nil {
            return false
        }
        for index in 0...videoViewModels.count where index < 2 && videoViewModels[index].image == nil && videoViewModels[index].videoURL == nil {
            return false
        }
        return true
    }
    func fetchProductDetailFromServer () {
        if let productId = currentProduct?.productStringId {
            SVProgressHUD.show()
            ServerManager.sharedInstance.getProductDetail(productId: productId) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.updateCurrentProductObject(product: response as! Product)
                    self.populateProductData()
                }
            }
        }
    }
    func updateCurrentProductObject(product: Product) {
        currentProduct?.isFavourite = product.isFavourite
        currentProduct?.posts = product.posts
        currentProduct?.sizeChart = product.sizeChart
    }
    func populateProductData() {
        var priceString = ""
        var searchPrice = 0.0
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + String(format: "%0.2f", searchPrice)
        }
        productPriceLabel.text = priceString
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            productDescriptionLabel.text = productName + "\n" +  productDescription
        }
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                brandImageView.sd_setImage(with: URL(string: brand.titleImage), completed: nil)
            }
        }
        assignImageURL()
    }
    func assignImageURL() {
        if var imageURL = currentProduct?.merchantImageURL {
            if imageURL == "" || imageURL.count < 4 {
                if let imageURLTarget = currentProduct?.imageURL {
                    productImageView.sd_setImage(with: URL(string: imageURLTarget), completed: nil)
                }
            } else {
                if imageURL.contains("|") {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
                productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
        } else if let imageURL = currentProduct?.imageURL {
            productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func submitButtonTapped(_ sender: Any) {
        if checkIfAllImagesAndVideoUploaded() == false {
            UtilityManager.showMessageWith(title: "Not so fast!", body: "Please include 2 photo looks and 2 video takes to Submit.", in: self)
        } else {
            if currentPost != nil {
                updatePostData()
            } else {
                uploadPOstData()
            }

        }
    }
    @IBAction func pictureDeleteButtonTapped(_ sender: Any) {
        if let index = pictureSelectedIndex {
            pictureViewModels[index].image = nil
            postImageView.image = nil
            pictureSelectedIndex = nil
            if let isVideo = pictureViewModels[index].isVideo, isVideo == true {
                pictureViewModels[index].videoURL = nil
                self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                return
            }
            if index > 3 {
                pictureViewModels.remove(at: index)
                self.imagesCollectionView.reloadData()
            } else {
                self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    @IBAction func videoDeleteButtonTapped(_ sender: Any) {
        if let index = videoSelectedIndex {
            videoViewModels[index].image = nil
            videoImageView.image = nil
            videoSelectedIndex = nil
            if let isVideo = videoViewModels[index].isVideo, isVideo == true {
                videoViewModels[index].videoURL = nil
                self.videosCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                return
            }
            if index > 3 {
                videoViewModels.remove(at: index)
                self.videosCollectionView.reloadData()
            } else {
                self.videosCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    func updatePostData() {
        if let post = currentPost {
            var dataDict = [String: Any]()
            var imagesToEditData: [Data] = []
            var imagesToUploadData: [Data] = []
            var index = 0
            var arrayOfImagesToEditIds = [Int]()
            var videoIdsToEdit: [Int]? = []
            var videoURLs: [URL] = []
            var videoURLsToEdit: [URL] = []
            for viewModel in pictureViewModels {
                if viewModel.imageURL != nil && viewModel.image != nil {
                    if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                        imagesToEditData.append(imageData)
                        let uploadId = post.uploads[index].uploadId
                        arrayOfImagesToEditIds.append(uploadId)
                    }
                } else if viewModel.imageURL == nil && viewModel.image != nil {
                    if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                        imagesToUploadData.append(imageData)
                    }
                }
                index = index + 1
            }
            var videoIndex = 0
            for viewModel in videoViewModels {
                if let urlForVideo = viewModel.videoURL {
                    if let videos = post.videos {
                        if videoIndex < videos.count - 1 {
                            let video = videos[videoIndex]
                            if urlForVideo != video.videoURL {
                                videoIdsToEdit?.append(videos[videoIndex].uploadId)
                                if let convertedURL = URL(string: urlForVideo) {
                                    videoURLsToEdit.append(convertedURL)
                                }
                            }
                            
                        } else {
                            if let convertedURL = URL(string: urlForVideo) {
                                if (urlForVideo.lowercased().hasPrefix("http")) == false {
                                    videoURLs.append(convertedURL)
                                }
                            }
                        }
                    }
//                    if let videos = post.videos, videos.count <= (videoIndex + 1) {
//                        videoIdsToEdit?.append(videos[videoIndex].uploadId)
//                        if let convertedURL = URL(string: urlForVideo) {
//                            videoURLsToEdit.append(convertedURL)
//                        }
//                    } else {
//                        if let convertedURL = URL(string: urlForVideo) {
//                            if (urlForVideo.lowercased().hasPrefix("http")) == false {
//                                videoURLs.append(convertedURL)
//                            }
//                        }
//                    }
                }
                videoIndex = videoIndex + 1
            }
            if arrayOfImagesToEditIds.count > 0 {
                dataDict["existing_images_ids"] = arrayOfImagesToEditIds.makeCommaSeparated()
            }
            if videoIdsToEdit!.count > 0 {
                dataDict["existing_videos_ids"] = videoIdsToEdit
            }
            dataDict["fit_tips"] = []
//            if videoURLsToEdit.count > 0 {
//                dataDict["videos_to_edit"] = videoURLsToEdit
//            }
//            if videoURLs.count > 0 {
//                dataDict["videos_to_upload"] = videoURLs
//            }
//            SVProgressHUD.setStatus("Please wait your data is been posted")
//            SVProgressHUD.setDefaultMaskType(.none)
//            SVProgressHUD.show()

            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Please wait, your content is being submitted"
             ServerManager.sharedInstance.editPostWithMultipleImagesAndVideos(params: dataDict, postId: post.postId, imagesToEdit: imagesToEditData, imagesToUploads: imagesToUploadData, videoURLs: videoURLs, videosToEditURLs: videoURLsToEdit) { (isSuccess, response) in
//                SVProgressHUD.dismiss()
                MBProgressHUD.hide(for: self.view, animated: true)
                if isSuccess {
                    self.currentTaskId = (response as! AddPostResponse).taskInfo.taskId
                    self.getPostProgress()
                } else {
                    self.submitButton.isEnabled = true
                }
            }
        }
    }
    func uploadPOstData() {
        var dataDict = [String: Any]()
        dataDict["product_id"] = currentProduct?.productStringId
        if let request = currentRequest {
            dataDict["product_request"] = request.requestId
            dataDict["size_worn"] = request.sizeValue
        }
        dataDict["fit_tips"] = []
        var imagesData: [Data] = []
        for viewModel in pictureViewModels {
            if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                imagesData.append(imageData)
            }
        }
        var videoURLs: [URL] = []
        for viewModel in videoViewModels {
            if let videoURL = viewModel.videoURL {
                if let convertedURL = URL(string: videoURL) {
                    videoURLs.append(convertedURL)
                }
            }
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        SVProgressHUD.setStatus("Please wait your data is been posted")
//        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait, your content is being submitted"
        ServerManager.sharedInstance.addPostWithMultipleImagesAndVideos(params: dataDict, imagesData: imagesData, videoURLs: videoURLs) { (isSuccess, response) in
//	            SVProgressHUD.dismiss()
            MBProgressHUD.hide(for: self.view, animated: true)

            if isSuccess {
                self.currentTaskId = (response as! AddPostResponse).taskInfo.taskId
                self.getPostProgress()
            } else {
                self.submitButton.isEnabled = true
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
            }
        }
    }
    func getPostProgress() {
        if let taskId = self.currentTaskId {
            ServerManager.sharedInstance.getPostProgress(taskId: taskId) { (isSuccess, response) in
                if isSuccess {
                    let taskInfo = (response as! ProgressResponse).taskInfo
                    if taskInfo.taskStatus == "SUCCESS" || taskInfo.taskStatus == "NOTREQUIRED" {
                        SVProgressHUD.dismiss()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        SegmentManager.createEventRequestSubmitted()
                        self.showThankYouController()
                        self.submitButton.isEnabled = true
                        self.perform(#selector(self.popViewController), with: nil, afterDelay: 3.0)
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "PostUploaded")))
                    } else if taskInfo.taskStatus == "FAILURE" {
                        SVProgressHUD.dismiss()
                    } else {
                        SVProgressHUD.showProgress(Float( taskInfo.info.progress.percent) / 100.0)
                        self.getPostProgress()
                    }
                }
            }
        }
    }
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    func showThankYouController() {
        let thankYouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouController") as! ThankYouController
        self.view.addSubview(thankYouVC.view)
    }

}
extension AddPostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return pictureViewModels.count
        } else {
            return videoViewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
        var viewModels = pictureViewModels
        if collectionView.tag == 1 {
            viewModels = videoViewModels
        }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModels[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 50.0, height: 80.0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = (UIScreen.main.bounds.size.width - 68)/5.0
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var viewModels = pictureViewModels
        if collectionView.tag == 1 {
            viewModels = videoViewModels
            videoSelectedIndex = indexPath.row
        } else {
            pictureSelectedIndex = indexPath.row
        }
        if viewModels[indexPath.row].image == nil {
            if viewModels[indexPath.row].isVideo == true {
                let videoPicker = self.storyboard?.instantiateViewController(withIdentifier: "VideoPickerVC") as! VideoPickerVC
                videoPicker.modalPresentationStyle = .fullScreen
                videoPicker.delegate = self
                self.present(videoPicker, animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                UtilityManager.openCustomCameraFrom(viewController: self, photoIndex: self.pictureSelectedIndex, progressTutorialVC: nil)
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.showPosePopup(index: self.pictureSelectedIndex)
//                UtilityManager.openGalleryFrom(viewController: self)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if viewModels[indexPath.row].imageURL != nil {
            self.postImageView.sd_setImage(with: viewModels[indexPath.row].imageURL, completed: nil)
        } else {
            self.postImageView.image = viewModels[indexPath.row].image
        }
    }
    func showPosePopup(index: Int?) {
        let popUpInstnc = PosePopupVC.instance(photoIndex: index)
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc)
        let options = PopupCustomOption.layout(.center)
        _ = popUpVC.customize([options])
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
            UtilityManager.openGalleryFrom(viewController: self)
        }
    }
}
extension AddPostVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.setupImage(pickedImage: image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
extension AddPostVC: CustomVideoRecorderDelegate {
    func customImagePickerController(_ picker: VideoPickerVC, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let videoURL = info["UIImagePickerControllerMediaURL"] as? URL {
            self.currentVideoURL = videoURL
            self.getThumbnailImageFromVideoUrl(url: videoURL) { (image) in
                if let pickedImage = image {
                    self.setupImage(pickedImage: pickedImage, videoURL: String(describing: videoURL))
                }
            }
        }
    }
    func setupImage(pickedImage: UIImage, videoURL: String? = nil) {
        var selectedIndex: Int?
        if videoURL == nil {
            selectedIndex = pictureSelectedIndex
        } else {
            selectedIndex = videoSelectedIndex
        }
        if let index = selectedIndex {
            let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 1080, height: (pickedImage.size.height/pickedImage.size.width)*1080))
            if videoURL == nil {
                pictureViewModels[index].image = scaledImg
                pictureViewModels[index].title = "Look " + String(index + 1)
                self.postImageView.image = scaledImg
                if index > 1 {
                    if index < 5 {
                        let viewModel = UploadPictureViewModel(title: "More Looks", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                        pictureViewModels.append(viewModel)
                    }
                }
                self.imagesCollectionView.reloadData()
            } else {
                videoViewModels[index].image = scaledImg
                videoViewModels[index].videoURL = videoURL
                videoViewModels[index].title = "Take " + String(index + 1)
                self.videoImageView.image = scaledImg
                if index > 1 {
                    if index < 5 {
                        let viewModel = UploadPictureViewModel(title: "Take " + String(index + 2), attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                        videoViewModels.append(viewModel)
                    }
                }
                self.videosCollectionView.reloadData()
            }
        }
    }
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}
extension AddPostVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showCropVC(image: pickedImage)
        }
    }
    func showCropVC(image: UIImage) {
        let cropVC = CropViewController(image: image)
        cropVC.delegate = self
        cropVC.customAspectRatio = CGSize(width: 4.0, height: 5.0)
//        cropVC.customAspectRatio = CGSize(width: 1.0, height: 1.0)
        cropVC.aspectRatioPickerButtonHidden = true
        cropVC.aspectRatioLockEnabled = true
        cropVC.aspectRatioLockDimensionSwapEnabled = true
        cropVC.resetButtonHidden = true
        cropVC.rotateButtonsHidden = true
        cropVC.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.toolbar.cancelTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.cropView.cropBoxResizeEnabled = false
        cropVC.cropView.gridOverlayHidden = true
        cropVC.cropView.setGridOverlayHidden(true, animated: true)
        let overlayVC = PhotoOverlayViewController(nibName: "PhotoOverlayViewController", bundle: .main)
        if let overlayView = overlayVC.view {
            overlayView.center = cropVC.cropView.center
            cropVC.cropView.addSubview(overlayView)
            cropVC.cropView.bringSubviewToFront(cropVC.cropView.gridOverlayView)
            cropVC.addChild(overlayVC)
            self.present(cropVC, animated: true) {
            }
        }
    }
}
extension AddPostVC: CaptureManagerDelegate {
    func processCapturedImage(image: UIImage) {
        if let index = pictureSelectedIndex {
            let scaledImg = image.scaleImageToSize(newSize: CGSize(width: 1080, height: (image.size.height/image.size.width)*1080))
            pictureViewModels[index].image = scaledImg
            self.postImageView.image = scaledImg
            if index > 2 {
                if index < 5 {
                    let viewModel = UploadPictureViewModel(title: "More Looks", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                    pictureViewModels.append(viewModel)
                }
            }
            UIImageWriteToSavedPhotosAlbum(scaledImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.imagesCollectionView.reloadData()
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            UtilityManager.showMessageWith(title: "Save Error", body: "You have to give picture save permissions in settings for this application", in: self)
        }
    }
}
