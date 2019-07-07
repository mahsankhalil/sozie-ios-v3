//
//  UploadPostAndFitTipsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/1/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class UploadPostAndFitTipsVC: UIViewController {
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

    var selectedSizeValue: String?
    var currentRequest: SozieRequest?
    var currentProduct: Product?
    var selectedIndex: Int?
    var selectedImage: UIImage?
    var isSizeSelected = false
    var fitTips: [FitTips]?
    var viewModels = [UploadPictureViewModel(title: "Front", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Back", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Side", attributedTitle: nil, imageURL: URL(string: ""), image: nil), UploadPictureViewModel(title: "Optional", attributedTitle: nil, imageURL: URL(string: ""), image: nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    func updateViews() {
        if self.checkIfAllQuestionsAnswered() == true {
            self.fitTipsCheckMark.isHidden = false
        }
        if isSizeSelected {
            self.sizeCheckMark.isHidden = false
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
        }
    }
    func checkIfAllImagesUplaoded() -> Bool {
        for index in 0...viewModels.count {
            if index < 3 {
                if viewModels[index].image == nil {
                    return false
                }
            }
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

    @IBAction func submitButtonTapped(_ sender: Any) {
        if self.checkIfAllImagesUplaoded() == false {
            UtilityManager.showErrorMessage(body: "Please Select all the images.", in: self)
        } else if self.checkIfAllQuestionsAnswered() == false {
            UtilityManager.showErrorMessage(body: "Please answer all Fit Tips.", in: self)
        } else if isSizeSelected == false {
            UtilityManager.showErrorMessage(body: "Please select size worn.", in: self)
        } else {
            var dataDict = [String: Any]()
            dataDict["product_id"] = currentProduct?.productStringId
            dataDict["size_worn"] = selectedSizeValue
            if let request = currentRequest {
                dataDict["product_request"] = request.requestId
            }
            var imagesData: [Data] = []
            for viewModel in viewModels {
                if let imageData = viewModel.image?.jpegData(compressionQuality: 1.0) {
                    imagesData.append(imageData)
                }
            }
            dataDict["fit_tips"] = self.makeFitTipsArray().toJSONString()
            SVProgressHUD.show()
            ServerManager.sharedInstance.addPostWithMultipleImages(params: dataDict, imagesData: imagesData) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    UtilityManager.showMessageWith(title: "THANK YOU!", body: "We are reviewing your post now", in: self, dismissAfter: 3)
                    self.perform(#selector(self.popViewController), with: nil, afterDelay: 3.0)
                } else {
                    UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
                }
            }
        }
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            viewModels[index].image = nil
            postImageView.image = nil
            selectedIndex = nil
            self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    @IBAction func postMakButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            let photoEditor = self.storyboard?.instantiateViewController(withIdentifier: "PhotoEditorViewController") as! PhotoEditorViewController
            photoEditor.photoEditorDelegate = self
            photoEditor.image = viewModels[index].image
            present(photoEditor, animated: true, completion: nil)
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
            UtilityManager.openImagePickerActionSheetFrom(viewController: self)
        } else {
            self.postImageView.image = viewModels[indexPath.row].image
        }
    }
}
extension UploadPostAndFitTipsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL, let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let index = selectedIndex {
                let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 750, height: (pickedImage.size.height/pickedImage.size.width)*750))
                viewModels[index].imageURL = pickedImageURL
                viewModels[index].image = scaledImg
                self.postImageView.image = scaledImg
                self.imagesCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        picker.dismiss(animated: true, completion: nil)
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
            let popUpVC = PopupController
                .create(self.tabBarController?.navigationController ?? self)
                .show(popUpInstnc)
            let options = PopupCustomOption.layout(.bottom)
            _ = popUpVC.customize([options])
            _ = popUpVC.didCloseHandler { (_) in
                self.updateViews()
            }
            popUpInstnc.closeHandler = { []  in
                popUpVC.dismiss()
            }
        } else if textField == fitTipsTextField {
            if let listOfFitTips = fitTips {
                let popUpInstnc = FitTipsNavigationController.instance(fitTips: listOfFitTips)
                popUpInstnc.delegate = self
                let popUpVC = PopupController
                    .create(self.tabBarController?.navigationController ?? self)
                    .show(popUpInstnc)
                let options = PopupCustomOption.layout(.bottom)
                _ = popUpVC.customize([options, .movesAlongWithKeyboard(true)])
                _ = popUpVC.didCloseHandler { (_) in
                    self.updateViews()
                }
                popUpInstnc.closeHandler = { []  in
                    popUpVC.dismiss()
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
