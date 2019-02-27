//
//  SoziesVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class SoziesVC: UIViewController {
    var reuseableIdentifier = "SozieTableViewCell"
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchVuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var viewModels: [SozieCellViewModel] = []
    var users: [User] = [] {
        didSet {
            for user in users {
                var brandImageURL = ""
                if let brandId = user.brand {
                    if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                        brandImageURL = brand.titleImage
                    }
                }
                let viewModel = SozieCellViewModel(isFollow: user.isFollowed, title: user.username, attributedTitle: nil, titleImageURL: URL(string: brandImageURL), bra: user.measurement?.bra, height: user.measurement?.height, hip: user.measurement?.hip, cup: user.measurement?.cup, waist: user.measurement?.waist, imageURL: nil )
                viewModels.append(viewModel)
            }
            if viewModels.count == 0 {
                noDataLabel.isHidden = false
            } else {
                noDataLabel.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    var dataDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        fetchDataFromServer()
    }
    //MARK: - Custom Methods
    func setupViews() {
        searchTextField.delegate = self
        searchVuHeightConstraint.constant = 0.0
        let gstrRcgnzr = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gstrRcgnzr.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gstrRcgnzr)
    }
    func showSearchVu() {
        searchVuHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchView.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
        }
    }
    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getMySozies(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.users = response as! [User]
            }
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func hideSearchVu() {
        searchVuHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 0.0
            self.searchView.clipsToBounds = true
            self.dismissKeyboard()
            self.view.layoutIfNeeded()
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
    @IBAction func crossButtonTapped(_ sender: Any) {
    }
    @IBAction func filterButtonTapped(_ sender: Any) {
        let popUpInstnc: PopupNavController? = PopupNavController.instance(type: nil, brandList: nil, filterType: FilterType.mySozies )
//        popUpInstnc?.popupDelegate = self
        let popUpVC = PopupController
            .create(self.tabBarController!)
        let options = PopupCustomOption.layout(.bottom)
        popUpVC.cornerRadius = 0.0
        _ = popUpVC.customize([options])
        _ = popUpVC.show(popUpInstnc!)
        popUpInstnc!.navigationHandler = { []  in
            UIView.animate(withDuration: 0.6, animations: {
                popUpVC.updatePopUpSize()
            })
        }
        popUpInstnc?.closeHandler = { [] in
            popUpVC.dismiss()
        }
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        if searchVuHeightConstraint.constant == 0 {
            showSearchVu()
        } else {
            hideSearchVu()
        }
    }
    
}
extension SoziesVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideSearchVu()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchVu()
        return true
    }
}
extension SoziesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseableIdentifier, bundle: nil), forCellReuseIdentifier: reuseableIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)
        }
        
        guard let cell = tableViewCell else { return UITableViewCell() }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        cell.selectionStyle = .none
        return cell
    }
}
