//
//  SelectWorkVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

struct BrandCellViewModel: RowViewModel, TitleViewModeling, CheckmarkViewModeling, ReuseIdentifierProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isCheckmarkHidden: Bool
    let reuseIdentifier = "TitleAndCheckmarkCell"
}

class SelectWorkVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: DZGradientButton!
    @IBOutlet weak var separatorVu: UIView!

    private var selectedBrandId: Int?
    private var selectedViewModelIndex: Int?
    private var brandList: [Brand]?
    private var signUpDict: [String: Any]?
    
    private var searchList: [Brand] = [] {
        didSet {
            viewModels.removeAll()
            if searchList.isEmpty {
                viewModels = [noSearchResultViewModel]
            } else {
                for brand in searchList {
                    let viewModel = BrandCellViewModel(title: brand.label, attributedTitle: nil, isCheckmarkHidden: true)
                    viewModels.append(viewModel)
                }
            }
        }
    }
    
    private lazy var noSearchResultViewModel: BrandCellViewModel = {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: "#F2A19C")
        ]
        let attributedTitle = NSAttributedString(string: "Search not found", attributes: attributes)
        return BrandCellViewModel(title: nil, attributedTitle: attributedTitle, isCheckmarkHidden: true)
    }()
    
    private var viewModels: [BrandCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        separatorVu.applyStandardContainerViewShadow()
        searchTxtFld.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        fetchDataFromServer()
    }
    
    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.brandList = self.removeTargetIfUS(brands: response as! [Brand])
                self.searchList = self.brandList ?? []
                self.tableView.reloadData()
            }
        }
    }
    func removeTargetIfUS(brands: [Brand]) -> [Brand] {
        var brandsList: [Brand] = []
        for brand in brands {
            if let dataDict = signUpDict {
                if let countryId = dataDict[User.CodingKeys.country.stringValue] as? Int {
                    if countryId == 1 {
                        if brand.brandId == 10 {
                            continue
                        }
                    }
                }
            }
            brandsList.append(brand)
        }
        return brandsList
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        searchList.removeAll()
        guard let brands = brandList, let searchText = textField.text else { return }
        if textField.text?.isEmpty ?? true {
            searchList = brandList ?? []
            self.tableView.reloadData()
            return
        }
        selectedBrandId = nil
        searchList = brands.filter { $0.label.range(of: searchText, options: .caseInsensitive) != nil}
        
        self.tableView.reloadData()
    }
    
    // MARK Text Field Delegate

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSignUpEmailVC" {
            let vc = segue.destination as! SignUpEmailVC
            vc.signUpDict = signUpDict
        }
    }
 
    
    // MARK: - Actions
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if let brandId = selectedBrandId {
            signUpDict![User.CodingKeys.brand.stringValue] = brandId
            performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
        } else {
            UtilityManager.showErrorMessage(body: "Please select Brand where you work.", in: self)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectWorkVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]

        var tableViewcell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        
        if tableViewcell == nil {
            tableView.register(UINib(nibName: viewModel.reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
            tableViewcell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        }
        
        guard let cell = tableViewcell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searchList.isEmpty {
            
            selectedBrandId = searchList[indexPath.row].brandId
            
            var indexPathsToReload = [indexPath]
            if let previousSelectedIndex = selectedViewModelIndex {
                viewModels[previousSelectedIndex].isCheckmarkHidden = true
                indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
            }
            
            viewModels[indexPath.row].isCheckmarkHidden = false
            selectedViewModelIndex = indexPath.row

            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
}

extension SelectWorkVC: SignUpInfoProvider {
    var signUpInfo: [String: Any]? {
        get { return signUpDict }
        set (newInfo) {
            signUpDict = newInfo
        }
    }
}
