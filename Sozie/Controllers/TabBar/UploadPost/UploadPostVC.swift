//
//  UploadPostVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class UploadPostVC: BaseViewController {

    @IBOutlet weak var postMaskButton: UIButton!
    @IBOutlet weak var postDeleteButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var sizeWornLabel: UILabel!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var bottomButtom: DZGradientButton!
    var currentProduct : Product?
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchProductDetailFromServer()
        if let image = selectedImage {
            self.postImageView.image = image
        }
        if let image = selectedImage {
            let imgData: NSData = NSData(data: image.jpegData(compressionQuality: 1.0)!)
            let imageSize: Int = imgData.length
            let imageSizeKbs = Double(imageSize) / 1024.0
            self.fileSizeLabel.text = "File size:" + String(format: "%0.0f",imageSizeKbs) + "kb"
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
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + " " + String(format: "%0.2f", searchPrice)
        }
        productPriceLabel.text = priceString
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            productDescriptionLabel.text = productName + "\n" +  productDescription
        }
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                brandImageView.sd_setImage(with:  URL(string: brand.titleImage), completed: nil)
            }
        }
        if let imageURL = currentProduct?.merchantImageURL {
            if let feedId = currentProduct?.feedId {
                if feedId == 18857 {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    productImageView.sd_setImage(with:  URL(string: url[0]), completed: nil)
                } else {
                    productImageView.sd_setImage(with:  URL(string: imageURL), completed: nil)
                }
            } else {
                productImageView.sd_setImage(with:  URL(string: imageURL), completed: nil)
            }
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
    @IBAction func bottomButtonTapped(_ sender: Any) {
    }
    @IBAction func postMakButtonTapped(_ sender: Any) {
    }
    @IBAction func postDeleteButton(_ sender: Any) {
    }
    
}
