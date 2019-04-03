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
            for product in productList {
                let viewModel = ProductImageCellViewModel(product: product, identifier: "WishTableViewCell")
                viewModels.append(viewModel)
            }
            noProductLabel.isHidden = viewModels.count != 0
            self.tableView.reloadData()
        }
    }
    var selectedProduct: Product?

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as? ProductDetailVC
        destVC?.currentProduct = selectedProduct
    }

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
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? WishTableViewCell {
            currentCell.delegate = self
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = productList[indexPath.row]
        performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
extension WishListVC: WishTableViewCellDelegate {
    func buyButtonTapped(button: UIButton) {
        let currentProduct = productList[button.tag]
//        if let productURL = currentProduct.deepLink {
//            guard let url = URL(string: productURL) else { return }
//            UIApplication.shared.open(url)
//        }
        if let productURL = currentProduct.deepLink {
            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            webVC.url = URL(string: productURL)
            webVC.modalPresentationStyle = .overFullScreen
            self.tabBarController?.navigationController?.present(webVC, animated: true, completion: nil)
        }
    }

    func crossButonTapped(btn: UIButton) {
        let index = btn.tag
        if let productId = productList[index].productStringId {
            ServerManager.sharedInstance.removeFavouriteProduct(productId: productId) { (_, _) in
            }
        }
        productList.remove(at: index)

    }
}
