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
    @IBOutlet weak var locationButton: UIButton!
    var productId: String?
    var productImage: String?
    var sku: String?
    var viewModels: [AdidasStoreViewModel] = []
    var timer: Timer?
    var progressTutorialVC: TutorialProgressVC?
    var cancelTutorialVC: NearbyCloseTutorialVC?
    var adidasStores: [AdidasRawStore]? {
        didSet {
            viewModels.removeAll()
            if let locations = adidasStores {
                for location in locations {
                    let isAvailable = self.checkIfProductAvailableIn(storeId: location.storeId)
                    let viewModel = AdidasStoreViewModel(count: 0, title: location.name.capitalizingFirstLetter(), attributedTitle: nil, description: location.street + "\n" + location.city, isAvailable: isAvailable)
                    viewModels.append(viewModel)
                }
                self.showNoDataLabelAccordingly()
                self.tableView.reloadData()
            }
        }
    }
    var availableStores = [AdidasStore]()
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
        progressTutorialVC?.delegate = self
        if appDelegate.currentLocation == nil {
            self.showNoDataLabelAccordingly()
        } else {
            fetchDataFromServer()
        }
    }
    func checkIfProductAvailableIn(storeId: String) -> Bool {
        for store in self.availableStores where store.storeId == storeId {
            if store.avaialable.lowercased() == "now" {
                return true
            }
        }
        return false
    }
    func showNoDataLabelAccordingly() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let locations = self.adidasStores else {
            self.noDataFoundLabel.isHidden = false
            if appDelegate.currentLocation == nil {
                self.noDataFoundLabel.text = "Click on the button below to ALLOW LOCATION ACCESS so that you can see what store to visit for this item!"
                self.locationButton.isHidden = false
            } else {
                self.noDataFoundLabel.text = "Your location did not match anything we have on file. Please try again. "
                self.locationButton.isHidden = true
            }
            return
        }
        self.noDataFoundLabel.isHidden = (locations.count != 0)
        self.locationButton.isHidden = (locations.count != 0)
        if locations.count == 0 {
            if appDelegate.currentLocation == nil {
                self.noDataFoundLabel.text = "Click on the button below to ALLOW LOCATION ACCESS so that you can see what store to visit for this item!"
                self.locationButton.isHidden = false
            } else {
                self.noDataFoundLabel.text = "Your location did not match anything we have on file. Please try again. "
                self.locationButton.isHidden = true
            }
        }
    }
    func makeDummyViewModels() {
        viewModels.removeAll()
        let viewModel1 = AdidasStoreViewModel(count: 0, title: "Originals Flagship Store London,", attributedTitle: nil, description: "Fouberts Place, 15 Fouberts Place, Carnaby Street, W1F 7QB London", isAvailable: true)
        let viewModel2 = AdidasStoreViewModel(count: 0, title: "Adidas Flagship Store London,", attributedTitle: nil, description: "425 Oxford street, W1C 2PG London", isAvailable: true)
        let viewModel3 = AdidasStoreViewModel(count: 0, title: "Adidas Store London, Westfield Stratford City,", attributedTitle: nil, description: "144-145 The Arcade, Westfield Stratford City, E20 1EL London", isAvailable: true)
        let viewModel4 = AdidasStoreViewModel(count: 0, title: "Adidas Brand Center London,", attributedTitle: nil, description: "Westfield Shopping Centre,Unit 5021/5521, W12 7GE London", isAvailable: true)
        let viewModel5 = AdidasStoreViewModel(count: 0, title: "Originals Flagship Store London,", attributedTitle: nil, description: "Hanbury Street, 15 Hanbury Street, Old Truman Brewery, E1 6QR London", isAvailable: true)
        viewModels.append(viewModel1)
        viewModels.append(viewModel2)
        viewModels.append(viewModel3)
        viewModels.append(viewModel4)
        viewModels.append(viewModel5)
//
//
//        for _ in 0...4 {
//            let viewModel = AdidasStoreViewModel(count: 0, title: "Originals Flagship Store London,", attributedTitle: nil, description: "15 Fouberts Place,London", isAvailable: true)
//            viewModels.append(viewModel)
//        }
        self.tableView.reloadData()
    }
    func excludeStoresNotRequired(stores: [AdidasRawStore]) -> [AdidasRawStore] {
        var requiredStores = [AdidasRawStore]()
        for store in stores {
            if store.storeId == "GB200893" || store.storeId == "GB501962" {
                continue
            } else {
                requiredStores.append(store)
            }
        }
        return requiredStores
    }
    func showNearByCancelTutorial() {
        if cancelTutorialVC == nil {
            cancelTutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "NearbyCloseTutorialVC") as? NearbyCloseTutorialVC
            progressTutorialVC?.updateProgress(progress: 3.0/8.0)
            if let nearByTutorialVC = cancelTutorialVC {
                nearByTutorialVC.view.frame.origin.y = 37.0
                nearByTutorialVC.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.size.height - 37.0)
                self.view.addSubview(nearByTutorialVC.view)
            }
        }
    }
    func removeCancelTutorialVC() {
        cancelTutorialVC?.view.removeFromSuperview()
    }
    class func instance(productId: String, productImage: String, sku: String, progreesVC: TutorialProgressVC?) -> StoresPopupListingVC {
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
            NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "LocationAvailable"), object: nil)
            var dataDict = [String: Any]()
            dataDict["isCnCRestricted"] = false
            dataDict["lat"] = appDelegate.currentLocation.coordinate.latitude
            dataDict["lng"] = appDelegate.currentLocation.coordinate.longitude
            dataDict["sku"] = sku?.uppercased()
            SVProgressHUD.show()
            AdidasAPIManager.sharedInstance.getNearbyStores(params: dataDict) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    let productResponse = response as! AdidasProductResponse
                    self.availableStores = productResponse.filteredStores
                    self.adidasStores = self.excludeStoresNotRequired(stores: productResponse.rawStores)
                    if UserDefaultManager.getIfPostTutorialShown() == false {
                        if let stores = self.adidasStores {
                            if stores.count == 0 {
                                self.makeDummyViewModels()
                            }
                        }
                        self.showNearByCancelTutorial()
                    }
                }
            }
        }
    }
    @IBAction func locationButtonTapped(_ sender: Any) {
        let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            DispatchQueue.main.async {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) //(url as URL)
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
extension StoresPopupListingVC: TutorialProgressDelegate {
    func tutorialSkipButtonTapped() {
        self.removeCancelTutorialVC()
        self.closeHandler!()
    }
}
