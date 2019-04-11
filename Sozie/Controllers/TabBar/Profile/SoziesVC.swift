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
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var popUpInstnc: PopupNavController? = PopupNavController.instance(type: nil, brandList: nil, filterType: FilterType.mySozies )
    var popUpVC: PopupController?
    var serverParams = [String: Any]()
    var viewModels: [SozieCellViewModel] = []
    var users: [User] = [] {
        didSet {
            viewModels.removeAll()
            for user in users {
                var brandImageURL = ""
                if let brandId = user.brand {
                    if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                        brandImageURL = brand.titleImage
                    }
                }
                let viewModel = SozieCellViewModel(user: user, brandImageURL: brandImageURL)
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
            if dataDict["filter_by"] != nil {
                searchLabel.text = String(viewModels.count) + (viewModels.count <= 1 ? " SOZIE FOLLOWED" : " SOZIES FOLLOWED")
                self.crossButton.isHidden = false
            } else if let queryBy = dataDict["query"] as? String {
                searchLabel.text = queryBy
                self.crossButton.isHidden = false
            } else {
                searchLabel.text = "ALL SOZIES"
                self.crossButton.isHidden = true
            }
        }
    }
    var dataDict = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromServer()
    }
    // MARK: - Custom Methods
    func setupViews() {
        searchTextField.delegate = self
        searchViewHeightConstraint.constant = 0.0
        let gstrRcgnzr = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gstrRcgnzr.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gstrRcgnzr)
    }

    func showSearchVu() {
        searchViewHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.searchViewHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchView.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
            self.searchTextField.becomeFirstResponder()
        }
    }

    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getMySozies(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.users = response as! [User]
                self.tableView.reloadData()
            }
        }
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func hideSearchVu() {
        searchViewHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchViewHeightConstraint.constant = 0.0
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
        users.removeAll()
        dataDict.removeAll()
        fetchDataFromServer()
        popUpInstnc = PopupNavController.instance(type: nil, brandList: nil, filterType: FilterType.mySozies )
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        popUpInstnc?.popupDelegate = self
        if popUpVC == nil {
            popUpVC = PopupController
                .create(self.tabBarController?.navigationController ?? self)
            let options = PopupCustomOption.layout(.bottom)
            _ = popUpVC?.customize([options])
        }
        popUpVC?.cornerRadius = 0.0
        popUpInstnc?.view.frame = UIScreen.main.bounds
        popUpInstnc?.view.transform = CGAffineTransform(scaleX: 1, y: 1)

        _ = popUpVC?.show(popUpInstnc!)
        popUpInstnc!.navigationHandler = { []  in
            UIView.animate(withDuration: 0.6, animations: {
                self.popUpVC?.updatePopUpSize()
            })
        }
        popUpInstnc?.closeHandler = { [] in
            self.popUpVC?.dismiss()
        }
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        if searchViewHeightConstraint.constant == 0 {
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
        dataDict.removeValue(forKey: "filter_by")
        dataDict["query"] = textField.text
        fetchDataFromServer()
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
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? SozieTableViewCell {
            currentCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            let sozieProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "SozieProfileVC") as! SozieProfileVC
            let currentUser = users[indexPath.row]
            sozieProfileVC.user = currentUser
            profileParentVC.navigationController?.pushViewController(sozieProfileVC, animated: true)
        }
    }
}
extension SoziesVC: PopupNavControllerDelegate {

    func doneButtonTapped(type: FilterType?, objId: Int?) {
        if let filterType = type {
            if filterType == FilterType.mySozies {
                if let typeId = objId {
                    if typeId == 0 {
                        dataDict["filter_by"] = "only_followed"
                    }
                }
            }
        }
        crossButton.isHidden = false
        fetchDataFromServer()
        users.removeAll()

    }
}
extension SoziesVC: SozieTableViewCellDelegate {

    func followButtonTapped(button: UIButton) {
        let currentUser = users[button.tag]
        if currentUser.isFollowed == false {
            var dataDict = [String: Any]()
            let userId = currentUser.userId
            dataDict["user"] = userId
            SVProgressHUD.show()
            ServerManager.sharedInstance.followUser(params: dataDict) { (isSuccess, _) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.users[button.tag].isFollowed = true
                    self.viewModels[button.tag].isFollow = true
                    self.tableView.reloadRows(at: [IndexPath(item: button.tag, section: 0)], with: .none)
                }
            }

        } else {
            var dataDict = [String: Any]()
            let userId = currentUser.userId
            dataDict["user"] = userId
            SVProgressHUD.show()
            ServerManager.sharedInstance.unFollowUser(params: dataDict) { (isSuccess, _) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.users[button.tag].isFollowed = false
                    self.viewModels[button.tag].isFollow = false
                    self.tableView.reloadRows(at: [IndexPath(item: button.tag, section: 0)], with: .none)
                }
            }
        }
    }
}
