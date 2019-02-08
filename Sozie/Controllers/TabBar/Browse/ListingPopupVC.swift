//
//  CategoryPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct DisclosureCellViewModel : RowViewModel, ReuseIdentifierProviding , TitleViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    let reuseIdentifier = "DisclosureCell"
}
class ListingPopupVC: UIViewController {

    private let reuseIdentifier = "DisclosureCell"

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tblVu: UITableView!
    var popupType : PopupType?
    var arrayOfDisclosureCellViewModel : [DisclosureCellViewModel] = []
    var brandList : [Brand]?
    var selectedCategory : Category?
    private var categoriesList : [Category] = [] {
        didSet {
            arrayOfDisclosureCellViewModel.removeAll()
            for category in categoriesList {
                let viewModel = DisclosureCellViewModel(title: category.categoryName, attributedTitle: nil)
                arrayOfDisclosureCellViewModel.append(viewModel)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.layer.cornerRadius = 10.0
        
    }
    func setPopupType(type : PopupType? , brandList : [Brand]?) {
        self.popupType = type
        self.brandList = brandList
        self.titleLbl.text = popupType?.rawValue
        if popupType == PopupType.category {
            fetchCategoriesFromServer()
        } else {
            arrayOfDisclosureCellViewModel.removeAll()
            let viewModel1 = DisclosureCellViewModel(title: "FILTER BY BRANDS", attributedTitle: nil)
            arrayOfDisclosureCellViewModel.append(viewModel1)
            let viewModel2 = DisclosureCellViewModel(title: "FILTER BY SOZIES", attributedTitle: nil)
            arrayOfDisclosureCellViewModel.append(viewModel2)
            self.tblVu.reloadData()
        }
    }
    
    func fetchCategoriesFromServer()
    {
        ServerManager.sharedInstance.getAllCategories(params: [:]) { (isSuccess, response) in
            if isSuccess {
                self.categoriesList = response as! [Category]
                self.tblVu.reloadData()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSubcategory"
        {
            let vc = segue.destination as! SelectionPopupVC
            vc.popupType = popupType
            if popupType == PopupType.category {
                vc.category = selectedCategory
            } else {
                vc.brandList = brandList
            }
        }
    }
    
    
}


extension ListingPopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDisclosureCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = arrayOfDisclosureCellViewModel[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier:viewModel.reuseIdentifier)
        }
        
        guard let cell = tableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if popupType == PopupType.category {
            selectedCategory = categoriesList[indexPath.row]
        } else if indexPath.row == 1 {
            return
        }
        
        performSegue(withIdentifier: "toSubcategory", sender: self)
    }
    
}
