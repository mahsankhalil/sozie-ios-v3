//
//  UploadPostAndFitTipsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
import TPKeyboardAvoiding
import UserNotifications
import CropViewController
import AVKit
import SDWebImage
protocol UploadPostAndFitTipsDelegate: class {
    func uploadPostInfoButtonTapped()
}
class UploadPostAndFitTipsVC: BaseViewController {
    @IBOutlet weak var postMaskButton: UIButton!
    @IBOutlet weak var postDeleteButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var bottomButtom: DZGradientButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var fitTipsTextField: UITextField!
    @IBOutlet weak var fitTipsCheckMark: UIImageView!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    var progressTutorialVC: TutorialProgressVC?
    var popUpVC: PopupController?
    var selectedSizeValue: String?
    var currentRequest: SozieRequest?
    var currentProduct: Product?
    var selectedIndex: Int?
    var selectedImage: UIImage?
    var isSizeSelected = false
    var fitTips: [FitTips]?
    weak var delegate: UploadPostAndFitTipsDelegate?
    var picturesTutorialVC: SelectPicturesTutorialVC?
    var fitTipsTutorialVC: AddFitTipsTutorialVC?
    var submitTutorialVC: SubmitPostTutorialVC?
    var isTutorialShowing: Bool = false
    var isFitTipsTutorialShown: Bool = false
    var isFromProductDetail = false
    var currentVideoURL: URL?
    var viewModels = [UploadPictureViewModel(title: "Front", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "Back", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "Side", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "Optional Picture", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: false), UploadPictureViewModel(title: "Optional Video", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true)]

    var currentTaskId: String?
    var currentPostId: Int?
    var currentPost: UserPost?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postMaskButton.isHidden = true
        // Do any additional setup after loading the view.
        if currentProduct == nil {
            currentProduct = currentRequest?.requestedProduct
            fetchProductDetailFromServer()
        } else {
            populateProductData()
        }
        if let frontImage = selectedImage {
            viewModels[0].image = frontImage
        }
        if let postID = currentPostId {
            self.getCurrentPost(postId: postID)
            self.postDeleteButton.isHidden = true
        }
        if isFromProductDetail == false {
            self.showInfoButton()
        }
        self.postImageView.layer.borderWidth = 1.0
        self.postImageView.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
        self.fitTipsCheckMark.isHidden = true
        fetchFitTipsFromServer()
        progressTutorialVC?.delegate = self
    }
    func getCurrentPost(postId: Int) {
        ServerManager.sharedInstance.getCurrentPostWith(postID: postId) { (isSuccess, response) in
            if isSuccess {
                let currentPost = response as! UserPost
                self.currentPost = currentPost
                self.populateDataWithCurrentPost()
                self.populateFitTips()
            }
        }
    }
    func populateDataWithCurrentPost() {
        viewModels.removeAll()
        if let post = currentPost {
            var index = 0
            for upload in post.uploads {
                var title = ""
                if index == 0 {
                    title = "Front"
                } else if index == 1 {
                    title = "Back"
                } else if index == 2 {
                    title = "Side"
                } else {
                    title = "Optional Picture"
                }
                let viewModel = UploadPictureViewModel(title: title, attributedTitle: nil, imageURL: URL(string: upload.imageURL), image: nil)
                index = index + 1
                viewModels.append(viewModel)
            }
            for video in post.videos ?? [] {
                let viewModel = UploadPictureViewModel(title: "Optional Video", attributedTitle: nil, imageURL: nil, image: nil, isVideo: true, videoURL: video.videoURL)
                viewModels.append(viewModel)
                index = index + 1
            }
            if index < 6 {
                if index < 5 {
                    let optionalViewModel = UploadPictureViewModel(title: "Optional Picture", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                    viewModels.append(optionalViewModel)
                } else {
                    if let videos = post.videos {
                        if videos.count > 0 {
                            let optionalViewModel = UploadPictureViewModel(title: "Optional Picture", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                            viewModels.append(optionalViewModel)
                        }
                    }
                }
                if post.videos?.count == 0 {
                    let optionalVideoViewModel = UploadPictureViewModel(title: "Optional Video", attributedTitle: nil, imageURL: URL(string: ""), image: nil, isVideo: true)
                    viewModels.append(optionalVideoViewModel)
                }
            }
            self.postImageView.sd_setImage(with: URL(string: post.uploads[0].imageURL), completed: nil)
            self.imagesCollectionView.reloadData()
        }
    }
    func populateFitTips() {
        if let post = currentPost {
            if let fitTipAnswers = post.fitTipsAnswers {
                for fitTip in fitTipAnswers {
                    self.matchFitTipsAndPopulateAnswer(fitTip: fitTip)
                }
            }
        }
    }
    func matchFitTipsAndPopulateAnswer(fitTip: PostFitTips) {
        if let allFitTips = fitTips {
            var fitTipsIndex = 0
            for currentFitTip in allFitTips {
                var questionIndex = 0
                for question in currentFitTip.question {
                    if question.questionId == fitTip.questionId {
                        fitTips![fitTipsIndex].question[questionIndex].isAnswered = true
                        fitTips![fitTipsIndex].question[questionIndex].answer = fitTip.answerText
                    }
                    questionIndex = questionIndex + 1
                }
                fitTipsIndex = fitTipsIndex + 1
            }
        }
        if checkIfAllQuestionsAnswered() {
            self.fitTipsCheckMark.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if picturesTutorialVC == nil {
            if UserDefaultManager.getIfPostTutorialShown() == false {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.addPicturesTutorial()
            }
        }
    }
    func addPicturesTutorial() {
        picturesTutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPicturesTutorialVC") as? SelectPicturesTutorialVC
        progressTutorialVC?.updateProgress(progress: 6.0/8.0)
        if let tutVC = picturesTutorialVC {
            tutVC.view.frame.origin.y = 235.0
            tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 618)
            self.scrollView.addSubview(tutVC.view)
            self.scrollView.contentSizeToFit()
        }
    }
    func removePictureTutorial() {
        picturesTutorialVC?.view.removeFromSuperview()
    }
    func addFitTipsTutorial() {
        fitTipsTutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "AddFitTipsTutorialVC") as? AddFitTipsTutorialVC
        progressTutorialVC?.updateProgress(progress: 7.0/8.0)
        if let tutVC = fitTipsTutorialVC {
            tutVC.view.frame.origin.y = 398 - 74
            tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 165 + 74)
            self.scrollView.addSubview(tutVC.view)
            self.bottomButtom.isEnabled = false
            isFitTipsTutorialShown = true
        }
    }
    func removeFitTipsTutorial() {
        fitTipsTutorialVC?.view.removeFromSuperview()
    }
    func addSubmitTutorial() {
        submitTutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "SubmitPostTutorialVC") as? SubmitPostTutorialVC
        progressTutorialVC?.updateProgress(progress: 8.0/8.0)
        if let tutVC = submitTutorialVC {
            tutVC.view.frame.origin.y = 430 - 74
            tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 215 + 74)
            self.scrollView.addSubview(tutVC.view)
            self.bottomButtom.isEnabled = true
        }
    }
    override func infoButtonTapped() {
        delegate?.uploadPostInfoButtonTapped()
        self.navigationController?.popViewController(animated: true)
    }
    func updateViews() {
        if self.checkIfAllQuestionsAnswered() == true {
            self.fitTipsCheckMark.isHidden = false
            if submitTutorialVC == nil {
                if UserDefaultManager.getIfPostTutorialShown() == false {
                    self.removeFitTipsTutorial()
                    self.addSubmitTutorial()
                }
            }
        }
    }
    func checkIfAllQuestionsAnswered() -> Bool {
        if let fitTips = fitTips {
            for fitTip in fitTips {
                for quest in fitTip.question where quest.isAnswered == false {
                        return false
                }
            }
        }
        return true
    }
    func fetchFitTipsFromServer() {
        var dataDict = [String: Any]()
        if self.currentRequest != nil {
            dataDict["category_id"] = self.currentRequest?.requestedProduct?.categoryId
        } else {
            dataDict["category_id"] = self.currentProduct?.categoryId
        }
        ServerManager.sharedInstance.getAllFitTips(params: dataDict) { (isSuccess, response) in
            if isSuccess {
                self.fitTips = (response as! [FitTips])
                if self.currentPost != nil {
                    self.populateFitTips()
                }
            }
        }
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
    func fetchProductDetail(productId: String) {
        ServerManager.sharedInstance.getProductDetail(productId: productId) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.currentProduct = (response as! Product)
                self.populateProductData()
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
    func checkIfAllImagesUplaoded() -> Bool {
        for index in 0...viewModels.count where index < 3 && viewModels[index].image == nil && viewModels[index].imageURL == nil {
            return false
        }
        return true
    }
    func makeFitTipsArray() -> [[String: Any]] {
        var arrayOfData = [[String: Any]]()
        if let fitTips = fitTips {
            for fitTip in fitTips {
                for quest in fitTip.question {
                    var dict = [String: Any]()
                    dict["question_id"] = quest.questionId
                    dict["answer_text"] = quest.answer
                    arrayOfData.append(dict)
                }
            }
        }
        return arrayOfData
    }
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func checkPushNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // Already authorized
            } else {
                // Either denied or notDetermined
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
                    // add your own
                    let alertController = UIAlertController(title: "Notification Alert", message: "Enable notifications to get instant alerts\nBy enabling notifications, you can keep up to date with new requests from Sozie. ", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Enable Notifications", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                            })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Not Now", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
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
            var videoIdToEdit: Int?
            for viewModel in viewModels {
                if viewModel.isVideo == false || viewModel.isVideo == nil {
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
                } else {
                    if let urlForVideo = viewModel.videoURL {
                        if (urlForVideo.lowercased().hasPrefix("http")) == false {
                            if let videos = post.videos {
                                if videos.count > 0 {
                                    videoIdToEdit = videos[0].uploadId
                                }
                            }
                        }
                    }
                }
                index = index + 1
            }
            dataDict["fit_tips"] = self.makeFitTipsArray().toJSONString()
            if arrayOfImagesToEditIds.count > 0 {
                dataDict["existing_images_ids"] = arrayOfImagesToEditIds.makeCommaSeparated()
            }
            if self.currentVideoURL != nil {
                dataDict["video_to_edit_id"] = videoIdToEdit
            }
            SVProgressHUD.show()
            ServerManager.sharedInstance.editPostWithMultipleImages(params: dataDict, postId: post.postId, imagesToEdit: imagesToEditData, imagesToUploads: imagesToUploadData, videoURL: self.currentVideoURL) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.currentTaskId = (response as! AddPostResponse).taskInfo.taskId
                    self.getPostProgress(isTutorial: false)
                } else {
                    self.bottomButtom.isEnabled = true
                }
            }
        }
    }
    func uploadPOstData(isTutorial: Bool) {
        var dataDict = [String: Any]()
        dataDict["product_id"] = currentProduct?.productStringId
        if let request = currentRequest {
            dataDict["product_request"] = request.requestId
            dataDict["size_worn"] = request.sizeValue
        }
        if isTutorial {
            dataDict["posted_to_learn"] = true
        }
        var imagesData: [Data] = []
        for viewModel in viewModels {
            if viewModel.isVideo == nil || viewModel.isVideo == false {
                if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                    imagesData.append(imageData)
                }
            }
        }
        dataDict["fit_tips"] = self.makeFitTipsArray().toJSONString()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        SVProgressHUD.show()
        ServerManager.sharedInstance.addPostWithMultipleImages(params: dataDict, imagesData: imagesData, videoURL: self.currentVideoURL) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.currentTaskId = (response as! AddPostResponse).taskInfo.taskId
                self.getPostProgress(isTutorial: isTutorial)
            } else {
                self.bottomButtom.isEnabled = true
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
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
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        if isTutorial {
                            UserDefaultManager.setBrowserTutorialShown()
                            self.uploadTutorialData()
                        } else {
                            SegmentManager.createEventRequestSubmitted()
                            self.showThankYouController()
                            self.bottomButtom.isEnabled = true
                            self.perform(#selector(self.popViewController), with: nil, afterDelay: 3.0)
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "PostUploaded")))
                        }
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

    func showThankYouController() {
        let thankYouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouController") as! ThankYouController
        self.view.addSubview(thankYouVC.view)
    }
    func uploadTutorialData() {
        var dataDict = [String: Any]()
        dataDict["CheckStores"] = true
        dataDict["FindYourProductA"] = true
        dataDict["FindYourProductB"] = true
        dataDict["TryOnScreenA"] = true
        dataDict["TryOnScreenB"] = true
        dataDict["Camera"] = true
        dataDict["FitTip"] = true
        dataDict["Submit"] = true
        SVProgressHUD.show()
        ServerManager.sharedInstance.updateTutorial(params: dataDict) { (isSuccess, _) in
            SVProgressHUD.dismiss()
            self.bottomButtom.isEnabled = true
            if isSuccess {
                if var user = UserDefaultManager.getCurrentUserObject() {
                    user.isTutorialApproved = true
                    UserDefaultManager.updateUserObject(user: user)
                    SegmentManager.createEventTutorialCompleted()
                }
                if let tabBarContrlr = self.parent?.parent as? TabBarVC {
                    tabBarContrlr.tabBar.isUserInteractionEnabled = true
                    if let firstItem = tabBarContrlr.tabBar.items?[0], let secondItem = tabBarContrlr.tabBar.items?[1], let thirdItem = tabBarContrlr.tabBar.items?[2], let fourthItem = tabBarContrlr.tabBar.items?[3] {
                        firstItem.isEnabled = true
                        secondItem.isEnabled = true
                        thirdItem.isEnabled = true
                        fourthItem.isEnabled = true
                    }
                }
                UserDefaultManager.setPostTutorialShown()
                self.checkPushNotifications()
                self.progressTutorialVC?.view.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "PostUploaded")))
            }
        }
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        if isTutorialShowing {
            self.bottomButtom.isEnabled = false
            uploadPOstData(isTutorial: true)
            return
        }
        if self.checkIfAllImagesUplaoded() == false {
            UtilityManager.showErrorMessage(body: "Please upload pictures of all angles.", in: self)
        } else if self.checkIfAllQuestionsAnswered() == false {
            UtilityManager.showErrorMessage(body: "Please answer all Fit Tips.", in: self)
        } else {
            self.bottomButtom.isEnabled = false
            if currentPost != nil {
                self.updatePostData()
                return
            }
            uploadPOstData(isTutorial: false)
        }
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            viewModels[index].image = nil
            postImageView.image = nil
            selectedIndex = nil
            if let isVideo = viewModels[index].isVideo, isVideo == true {
                viewModels[index].videoURL = nil
                self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                return
            }
            if index > 3 {
                viewModels.remove(at: index)
                self.imagesCollectionView.reloadData()
            } else {
                self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    @IBAction func postMakButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            if let image = viewModels[index].image {
                let photoEditor = self.storyboard?.instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
                photoEditor.photoEditorDelegate = self
                photoEditor.image = image
                present(photoEditor, animated: true, completion: nil)
            }
        }
    }
}
extension UploadPostAndFitTipsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath)
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
        selectedIndex = indexPath.row
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
                UtilityManager.openCustomCameraFrom(viewController: self, photoIndex: self.selectedIndex, progressTutorialVC: self.progressTutorialVC)
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.showPosePopup(index: self.selectedIndex)
//                UtilityManager.openGalleryFrom(viewController: self)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if viewModels[indexPath.row].imageURL != nil {
            self.postImageView.sd_setImage(with: self.viewModels[indexPath.row].imageURL, completed: nil)
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
extension UploadPostAndFitTipsVC: CaptureManagerDelegate {
    func processCapturedImage(image: UIImage) {
        if let index = selectedIndex {
            let scaledImg = image.scaleImageToSize(newSize: CGSize(width: 1080, height: (image.size.height/image.size.width)*1080))
            viewModels[index].image = scaledImg
            self.postImageView.image = scaledImg
            if index > 2 {
                if index < 5 {
                    let viewModel = UploadPictureViewModel(title: "Optional Picture", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                    viewModels.append(viewModel)
                }
            }
            UIImageWriteToSavedPhotosAlbum(scaledImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.imagesCollectionView.reloadData()
        }
        if checkIfAllImagesUplaoded() {
            if UserDefaultManager.getIfPostTutorialShown() == false {
                removePictureTutorial()
                if isFitTipsTutorialShown == false {
                    addFitTipsTutorial()
                }
            }
        }
        if isTutorialShowing {
            self.progressTutorialVC?.view.isHidden = false
        }
    }
}
extension UploadPostAndFitTipsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    func setupImage(pickedImage: UIImage, videoURL: String? = nil) {
        if let index = selectedIndex {
            let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 1080, height: (pickedImage.size.height/pickedImage.size.width)*1080))
            viewModels[index].image = scaledImg
            viewModels[index].videoURL = videoURL
            self.postImageView.image = scaledImg
            if index > 2 {
                if index < 5 {
                    if viewModels[index].isVideo == false {
                        let viewModel = UploadPictureViewModel(title: "Optional Picture", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                        viewModels.append(viewModel)
                    }
                }
            }
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
extension UploadPostAndFitTipsVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.setupImage(pickedImage: image)
        if checkIfAllImagesUplaoded() {
            if UserDefaultManager.getIfPostTutorialShown() == false {
                removePictureTutorial()
                if isFitTipsTutorialShown == false {
                    addFitTipsTutorial()
                }
            }
        }
        if isTutorialShowing {
            self.progressTutorialVC?.view.isHidden = false
        }
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
extension UploadPostAndFitTipsVC: PhotoEditorDelegate {

    func doneEditing(image: UIImage) {
        if let index = selectedIndex {
            viewModels[index].image = image
            postImageView.image = image
            self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }

    func canceledEditing() {
        print("Canceled")
    }
}

extension UploadPostAndFitTipsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == fitTipsTextField {
            if let listOfFitTips = fitTips {
                let popUpInstnc = FitTipsNavigationController.instance(fitTips: listOfFitTips, product: self.currentProduct)
                popUpInstnc.delegate = self
                popUpVC = PopupController
                    .create(self.tabBarController?.navigationController ?? self)
                    .show(popUpInstnc)
                let options = PopupCustomOption.layout(.bottom)
                _ = popUpVC?.customize([options, .movesAlongWithKeyboard(true)])
                _ = popUpVC?.didCloseHandler { (_) in
                    self.updateViews()
                }
                popUpInstnc.closeHandler = { []  in
                    self.popUpVC?.dismiss()
                }
                popUpInstnc.navigationHandler = { []  in
                    UIView.animate(withDuration: 0.6, animations: {
                        self.popUpVC?.updatePopUpSize()
                    })
                }
            }
        }
    }
}
extension UploadPostAndFitTipsVC: TutorialProgressDelegate {
    func tutorialSkipButtonTapped() {
        self.removeFitTipsTutorial()
        self.removePictureTutorial()
        self.addSubmitTutorial()
        self.navigationController?.popViewController(animated: true)
        self.popUpVC?.dismiss()
    }
}
extension UploadPostAndFitTipsVC: CustomVideoRecorderDelegate {
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
