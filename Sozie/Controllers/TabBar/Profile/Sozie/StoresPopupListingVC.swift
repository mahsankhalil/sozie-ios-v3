//
//  StoresPopupListingVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/20/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class StoresPopupListingVC: UIViewController {
    private let reuseIdentifier = "StoreCell"
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    var productId: String?
    var productImage: String?
    var sku: String?
    var viewModels: [AdidasStoreViewModel] = []
    var timer: Timer?
    var adidasStores: [AdidasStore]? {
        didSet {
            viewModels.removeAll()
            if let locations = adidasStores {
                for location in locations {
                    var isAvailable = false
                    if location.avaialable == "Y" {
                        isAvailable = true
                    }
                    let viewModel = AdidasStoreViewModel(count: 0, title: location.name.capitalizingFirstLetter(), attributedTitle: nil, description: location.street + "\n" + location.city, isAvailable: isAvailable)
                    viewModels.append(viewModel)
                }
                self.noDataFoundLabel.isHidden = (locations.count != 0)
                self.tableView.reloadData()
            }
        }
    }
    var closeHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setupLocationManager()
        if let imageURL = productImage {
            productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataFromServer), name: Notification.Name(rawValue: "LocationAvailable"), object: nil)
    }
    func excludeStoresNotRequired(stores: [AdidasStore]) -> [AdidasStore] {
        var requiredStores = [AdidasStore]()
        for store in stores {
            if store.storeId == "GB200893" || store.storeId == "GB501962" {
                continue
            } else {
                requiredStores.append(store)
            }
        }
        return requiredStores
    }
    class func instance(productId: String, productImage: String, sku: String) -> StoresPopupListingVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "StoresPopupListingVC") as! StoresPopupListingVC
        instnce.productId = productId
        instnce.productImage = productImage
        instnce.sku = sku
        return instnce
    }
    @objc func fetchDataFromServer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.currentLocation != nil {
            var dataDict = [String: Any]()
            dataDict["isCnCRestricted"] = false
            dataDict["lat"] = appDelegate.currentLocation.coordinate.latitude
            dataDict["lng"] = appDelegate.currentLocation.coordinate.longitude
            dataDict["sku"] = sku
            SVProgressHUD.show()
            AdidasAPIManager.sharedInstance.getNearbyStores(params: dataDict) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    let productResponse = response as! AdidasProductResponse
                    self.adidasStores = self.excludeStoresNotRequired(stores: productResponse.rawStores)
                }
            }
        }
    }
    @IBAction func closeButtontapped(_ sender: Any) {
        self.closeHandler!()
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
extension StoresPopupListingVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: UIScreen.main.bounds.size.height - 200.0)
    }
}
extension StoresPopupListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let viewModel = viewModels[indexPath.row]
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }
}
