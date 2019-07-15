//
//  StoresPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

class StoresPopupVC: UIViewController {

    private let reuseIdentifier = "StoreCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var findButton: DZGradientButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    var productId: String?
    var productImage: String?
    var viewModels: [StoreViewModel] = []
    var timer: Timer?
    var nearbyString: String?
    var targetProduct: TargetProduct? {
        didSet {
            viewModels.removeAll()
            if let locations = targetProduct?.locations {
                for location in locations {
                    let viewModel = StoreViewModel(count: location.locationAvailableQuantity, title: location.storeName, attributedTitle: nil, description: location.storeAddress)
                    viewModels.append(viewModel)
                }
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
//        SVProgressHUD.show()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getStoresList), userInfo: nil, repeats: true)
        if let imageURL = productImage {
            productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
    }
    @objc func getStoresList() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.currentLocation != nil {
            timer?.invalidate()
            SVProgressHUD.dismiss()
            if nearbyString == nil {
                nearbyString = String(appDelegate.currentLocation.coordinate.latitude) + "," + String(appDelegate.currentLocation.coordinate.longitude)
            }
            fetchDataFromServer()
        }
    }
    func fetchDataFromServer() {
        var dataDict = [String: Any]()
        dataDict["key"] = "eb2551e4accc14f38cc42d32fbc2b2ea"
        dataDict["nearby"] = nearbyString
        dataDict["limit"] = 20
        dataDict["requested_quantity"] = 1
        dataDict["radius"] = 100
        dataDict["include_only_available_stores"] = true
        TargetAPIManager.sharedInstance.getNearbyStores(productId: productId!, params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.targetProduct = (response as! ProductResponse).products[0]
            }
        }
    }
    class func instance(productId: String, productImage: String) -> StoresPopupVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "StoresPopupVC") as! StoresPopupVC
        instnce.productId = productId
        instnce.productImage = productImage
        return instnce
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        timer?.invalidate()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.locationManager?.startUpdatingLocation()
        if let currentLocation = appDelegate.currentLocation {
            nearbyString = String(currentLocation.coordinate.latitude) + "," + String(currentLocation.coordinate.longitude)
            fetchDataFromServer()
        }
    }
    @IBAction func findButtonTapped(_ sender: Any) {
        timer?.invalidate()
        if textField.text?.isEmpty == true {
            UtilityManager.showMessageWith(title: "Warning!", body: "Please enter city/zip code to search.", in: self)
        } else {
            nearbyString = textField.text
            fetchDataFromServer()
        }
    }
    @IBAction func closeButtontapped(_ sender: Any) {
        timer?.invalidate()
        self.closeHandler!()
    }
}
extension StoresPopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 26.0, height: UIScreen.main.bounds.size.height - 200.0)
    }
}
extension StoresPopupVC: UITableViewDelegate, UITableViewDataSource {
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
