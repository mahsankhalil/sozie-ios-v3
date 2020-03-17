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
//import FirebaseAnalytics
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
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var fitTipsTextField: UITextField!
    @IBOutlet weak var sizeCheckMark: UIImageView!
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
    var viewModels = [UploadPictureViewModel(title: "Front", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Back", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Side", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Optional", attributedTitle: nil, imageURL: URL(string: ""), image: nil)]
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
        self.postImageView.layer.borderWidth = 1.0
        self.postImageView.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
        self.sizeCheckMark.isHidden = true
        self.fitTipsCheckMark.isHidden = true
        fetchFitTipsFromServer()
        self.showInfoButton()
        progressTutorialVC?.delegate = self
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
//        if let tabBarContrlr = self.parent?.parent as? TabBarVC {
//            tabBarContrlr.tabBar.isUserInteractionEnabled = false
//            if let firstItem = tabBarContrlr.tabBar.items![0] as? UITabBarItem, let secondItem = tabBarContrlr.tabBar.items![1] as? UITabBarItem, let thirdItem = tabBarContrlr.tabBar.items![2] as? UITabBarItem, let fourthItem = tabBarContrlr.tabBar.items![0] as? UITabBarItem {
//                firstItem.isEnabled = false
//                secondItem.isEnabled = false
//                thirdItem.isEnabled = false
//                fourthItem.isEnabled = false
//            }
//        }
        progressTutorialVC?.updateProgress(progress: 6.0/8.0)
        if let tutVC = picturesTutorialVC {
            tutVC.view.frame.origin.y = 215.0
            tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 638)
            self.scrollView.addSubview(tutVC.view)
            self.scrollView.contentSizeToFit()
        }
    }
    func removePictureTutorial() {
        picturesTutorialVC?.view.removeFromSuperview()
    }
    func addFitTipsTutorial() {
        //563-165
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
//        if isSizeSelected {
//            self.sizeCheckMark.isHidden = false
//        }
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
        ServerManager.sharedInstance.getAllFitTips(params: [:]) { (isSuccess, response) in
            if isSuccess {
                self.fitTips = (response as! [FitTips])
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
    func updateCurrentProductObject(product: Product) {
        currentProduct?.isFavourite = product.isFavourite
        currentProduct?.posts = product.posts
        currentProduct?.sizeChart = product.sizeChart
    }
    func populateProductData() {
        var priceString = ""
        var searchPrice = 0.0
        //        let currentProduct = self.currentProduct
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
            if imageURL == "" {
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
        for index in 0...viewModels.count where index < 3 && viewModels[index].image == nil {
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
            if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                imagesData.append(imageData)
            }
        }
        dataDict["fit_tips"] = self.makeFitTipsArray().toJSONString()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        SVProgressHUD.show()
        ServerManager.sharedInstance.addPostWithMultipleImages(params: dataDict, imagesData: imagesData) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                if isTutorial {
                    UserDefaultManager.setBrowserTutorialShown()
                    self.uploadTutorialData()
                } else {
                    SegmentManager.createEventRequestSubmitted()
//                    UtilityManager.showMessageWith(title: "THANK YOU!", body: "We are reviewing your post now", in: self, dismissAfter: 3)
                    self.showThankYouController()
                    self.bottomButtom.isEnabled = true
                    self.perform(#selector(self.popViewController), with: nil, afterDelay: 3.0)
                }
            } else {
                self.bottomButtom.isEnabled = true
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
            }
        }
    }
    func showThankYouController() {
        let thankYouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouController") as! ThankYouController
        self.view.addSubview(thankYouVC.view)
    }
    func uploadTutorialData() {
        var dataDict = [String: Any]()
        dataDict["CheckStores"] = false
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
//                    Analytics.logEvent("Tutorial-Completed", parameters: ["email": user.email])
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
            uploadPOstData(isTutorial: false)
        }
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            viewModels[index].image = nil
            viewModels[index].imageURL = nil
            postImageView.image = nil
            selectedIndex = nil
            if index > 2 {
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
            return CGSize(width: 50.0, height: 65.0)
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
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                let imagePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "RequestImagePickerController") as! RequestImagePickerController
                imagePickerVC.delegate = self
                imagePickerVC.photoIndex = self.selectedIndex
                imagePickerVC.modalPresentationStyle = .fullScreen
                self.progressTutorialVC?.view.isHidden = true
                self.present(imagePickerVC, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                UtilityManager.openGalleryFrom(viewController: self)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.postImageView.image = viewModels[indexPath.row].image
        }
    }
}
extension UploadPostAndFitTipsVC: CaptureManagerDelegate {
    func processCapturedImage(image: UIImage) {
        if let index = selectedIndex {
            let scaledImg = image.scaleImageToSize(newSize: CGSize(width: 750, height: (image.size.height/image.size.width)*750))
            viewModels[index].image = scaledImg
            self.postImageView.image = scaledImg
            if index > 2 {
                if index < 5 {
                    let viewModel = UploadPictureViewModel(title: "Optional", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                    viewModels.append(viewModel)
                }
                viewModels[index].title = ""
            }
            UIImageWriteToSavedPhotosAlbum(scaledImg, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            self.imagesCollectionView.reloadData()
        }
        if checkIfAllImagesUplaoded() {
            if UserDefaultManager.getIfPostTutorialShown() == false {
                removePictureTutorial()
                if isFitTipsTutorialShown == false {
                    addFitTipsTutorial()
                    self.imagesCollectionView.isUserInteractionEnabled = false
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
//            self.setupImage(pickedImage: pickedImage)
            self.showCropVC(image: pickedImage)
        }
    }
    func showCropVC(image: UIImage) {
        let cropVC = CropViewController(image: image)
        cropVC.delegate = self
        cropVC.customAspectRatio = CGSize(width: 9.0, height: 16.0)
        cropVC.aspectRatioPickerButtonHidden = true
        cropVC.aspectRatioLockEnabled = true
        cropVC.resetButtonHidden = true
        cropVC.rotateButtonsHidden = true
        cropVC.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.toolbar.cancelTextButton.setTitleColor(UIColor.white, for: .normal)
        cropVC.cropView.gridOverlayHidden = true
        cropVC.cropView.setGridOverlayHidden(true, animated: true)
        let imgVu = UIImageView(image: UIImage(named: "Canvas-Gallery"))
        var image: UIImage?
        if let index = selectedIndex {
            switch index {
            case 0:
                image = UIImage(named: "Front")
            case 1:
                image = UIImage(named: "Back")
            case 2:
                image = UIImage(named: "Side")
            default:
                image = nil
            }
        } else {
            image = nil
        }
        let tutorialImageView = UIImageView(image: image)
        tutorialImageView.frame.origin.x = UIScreen.main.bounds.size.width - 68
        tutorialImageView.frame.origin.y = 20
        imgVu.center = cropVC.cropView.center
        imgVu.frame = cropVC.cropView.cropBoxFrame
        cropVC.cropView.addSubview(imgVu)
        self.present(cropVC, animated: true) {
            imgVu.frame = cropVC.cropView.cropBoxFrame
        }
        cropVC.cropView.addSubview(tutorialImageView)
    }
    func setupImage(pickedImage: UIImage) {
        if let index = selectedIndex {
            let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 750, height: (pickedImage.size.height/pickedImage.size.width)*750))
            viewModels[index].image = scaledImg
            self.postImageView.image = scaledImg
            if index > 2 {
                if index < 5 {
                    let viewModel = UploadPictureViewModel(title: "Optional", attributedTitle: nil, imageURL: URL(string: ""), image: nil)
                    viewModels.append(viewModel)
                }
                viewModels[index].title = ""
            }
            self.imagesCollectionView.reloadData()
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            UtilityManager.showMessageWith(title: "Save Error", body: error.localizedDescription, in: self)
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
                    self.imagesCollectionView.isUserInteractionEnabled = false
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
        if textField == sizeTextField {
            let popUpInstnc = SizePickerPopupVC.instance(productSizeChart: currentProduct?.sizeChart, currentProductId: currentProduct?.productStringId, brandid: currentProduct?.brandId)
            popUpInstnc.delegate = self
            popUpVC = PopupController
                .create(self.tabBarController?.navigationController ?? self)
                .show(popUpInstnc)
            let options = PopupCustomOption.layout(.bottom)
            _ = popUpVC?.customize([options])
            _ = popUpVC?.didCloseHandler { (_) in
                self.updateViews()
            }
            popUpInstnc.closeHandler = { []  in
                self.popUpVC?.dismiss()
            }
        } else if textField == fitTipsTextField {
            if let listOfFitTips = fitTips {
                let popUpInstnc = FitTipsNavigationController.instance(fitTips: listOfFitTips)
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
extension UploadPostAndFitTipsVC: RequestSizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: String?) {
        selectedSizeValue = value
        sizeTextField.text = selectedSizeValue
        isSizeSelected = true
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
