//
//  WishListVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class WishListVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noProductLabel: UILabel!
    private var viewModels: [ProductImageCellViewModel] = []
    private var productList: [Product] = [] {
        didSet {
            viewModels.removeAll()
            var index = 0
            for product in productList {
                var imageURL = ""
                if let productImageURL = product.imageURL {
                    imageURL = productImageURL.getActualSizeImageURL() ?? ""
                }
                var brandImageURL = ""
                if let brandId = product.brandId {
                    if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                        brandImageURL = brand.titleImage
                    }
                }
                var searchPrice = 0.0
                if let price = product.searchPrice {
                    searchPrice = Double(price)
                }
                var postCount = 0
                if let count = product.postCount {
                    postCount = count
                }
                var priceString = ""
                if let currency = product.currency?.getCurrencySymbol() {
                    priceString = currency + " " + String(format: "%0.2f", searchPrice)
                }
                var productDescription = ""
                if let description = product.description {
                    productDescription = description
                }
                let viewModel = ProductImageCellViewModel(index: index, count: postCount, title: priceString, attributedTitle: nil, titleImageURL: URL(string: brandImageURL), imageURL: URL(string: imageURL), description: productDescription, reuseIdentifier: "WishTableViewCell")
                viewModels.append(viewModel)
                index = index + 1
            }
            if viewModels.count == 0 {
                noProductLabel.isHidden = false
            } else {
                noProductLabel.isHidden = true
            }
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
        assignNoProductLabel()
        self.tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        fetchFavouriteListFromServer()
    }
    func assignNoProductLabel() {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named: "Wish List Selected")
        //Set bound to reposition
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "Click on the ")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: " \n under your favourite picture or\n Sozie to save it here for viewing later")
        completeText.append(textAfterIcon)
        self.noProductLabel.textAlignment = .center
        self.noProductLabel.attributedText = completeText
    }

    func fetchFavouriteListFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getFavouriteList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.productList = response as! [Product]
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

}
extension WishListVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)

        if tableViewCell == nil {
            tableView.register(UINib(nibName: viewModel.reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        }

        guard let cell = tableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let currentCell = cell as? WishTableViewCell {
            currentCell.delegate = self
        }

        return cell
    }
}
extension WishListVC: WishTableViewCellDelegate {
    func crossButonTapped(btn: UIButton) {
        let index = btn.tag
        let productId = productList[index].productId
        ServerManager.sharedInstance.removeFavouriteProduct(productId: productId) { (_, _) in
        }
        productList.remove(at: index)

    }
}
