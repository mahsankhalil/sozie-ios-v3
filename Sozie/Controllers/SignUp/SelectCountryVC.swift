//
//  SelectCountryVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SignUpInfoProvider {
    var signUpInfo: [String: Any]? { get set }
}

struct CountryCellViewModel: RowViewModel, TitleViewModeling, CheckmarkViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isCheckmarkHidden: Bool
}

class SelectCountryVC: UIViewController {

    private let reuseIdentifier = "TitleAndCheckmarkCell"
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: DZGradientButton!
    @IBOutlet weak var tableView: UITableView!
    
    var countries: [Country]?
    var selectedCountryId: Int?
    var currentUserType: UserType?
    var signUpDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDataFromServer()
    }

    // MARK: - Custom Methods
    
    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getCountriesList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.countries = response as? [Country]
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
    }

    // MARK: - Actions
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if let countryid = selectedCountryId {
            signUpDict[User.CodingKeys.country.stringValue] = countryid
            signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
            if currentUserType == .shopper {
                performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
            } else if currentUserType == .sozie {
                performSegue(withIdentifier: "toWorkVC", sender: self)
            }
        } else {
            UtilityManager.showErrorMessage(body: "Please select Country.", in: self)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
}

extension SelectCountryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier)
        }
        
        guard let countries = countries, let cell = tableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        let country = countries[indexPath.row]
        let model = CountryCellViewModel(title: country.code, attributedTitle: nil, isCheckmarkHidden: (selectedCountryId != country.countryId))
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let countries = countries else { return }
        
        var indexesToReload = [indexPath]
        
        if  let selectedCountryId = selectedCountryId,
            let previousRow = countries.index(where: { $0.countryId == selectedCountryId }) {
            indexesToReload.append(IndexPath(row: previousRow, section: 0))
        }
        
        self.selectedCountryId = countries[indexPath.row].countryId
        tableView.reloadRows(at: indexesToReload, with: .automatic)
    }
    
}
