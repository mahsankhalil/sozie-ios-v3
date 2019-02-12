//
//  ProductDetailVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class ProductDetailVC: BaseViewController {

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var requestSozieButton: DZGradientButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buyButton: DZGradientButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    var currentProduct : Product?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
        populateProductData()

    }
    
    func populateProductData()
    {
        if let imageURL = currentProduct?.imageURL.getActualSizeImageURL() {
            productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
        priceLabel.text = String(currentProduct!.searchPrice)
        if let productName = currentProduct?.productName , let productDescription = currentProduct?.description {
            descriptionTextLabel.text = productName + "\n" +  productDescription
        }
        
        brandImageView.sd_setImage(with: URL(string: (currentProduct?.brand.titleImage)!), completed: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK : - Actions
    @IBAction func requestSozieButtonTapped(_ sender: Any) {
    }
    
    @IBAction func butButtonTapped(_ sender: Any) {
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    @IBAction func heartButtonTapped(_ sender: Any) {
    }
}
