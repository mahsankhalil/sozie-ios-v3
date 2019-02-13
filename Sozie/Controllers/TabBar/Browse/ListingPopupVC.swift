//
//  CategoryPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
public enum FilterType : String {
    case category = "CATEGORY"
    case filter = "FILTER"
    case sozie = "SOZIE"
}
struct DisclosureCellViewModel : RowViewModel, ReuseIdentifierProviding , TitleViewModeling , CheckmarkViewModeling {
    var isCheckmarkHidden: Bool = true
    var title: String?
    var attributedTitle: NSAttributedString?
    var reuseIdentifier : String = "DisclosureCell"
}
protocol ListingPopupVCDelegate {
    func doneButtonTapped(type : FilterType? , id : Int?)
}
class ListingPopupVC: UIViewController {

    var delegate : ListingPopupVCDelegate?

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var popupType : PopupType?
    var viewModels : [DisclosureCellViewModel] = []
    var brandList : [Brand]?
    var selectedCategory : Category?
    private var selectedViewModelIndex: Int?
    private var categoriesList : [Category] = [] {
        didSet {
            viewModels.removeAll()
            for category in categoriesList {
                var viewModel = DisclosureCellViewModel()
                viewModel.title = category.categoryName
                viewModels.append(viewModel)
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
        self.titleLabel.text = popupType?.rawValue
        if popupType == PopupType.category {
            fetchCategoriesFromServer()
        } else {
            viewModels.removeAll()
            var viewModel1 = DisclosureCellViewModel()
            viewModel1.title = "FILTER BY BRANDS"
            viewModels.append(viewModel1)
            var viewModel2 = DisclosureCellViewModel()
            viewModel2.title = "FILTER BY SOZIES"
            viewModel2.reuseIdentifier = "TitleAndCheckmarkCell"
            viewModels.append(viewModel2)
            self.tableView.reloadData()
        }
    }
    
    func fetchCategoriesFromServer()
    {
        ServerManager.sharedInstance.getAllCategories(params: [:]) { (isSuccess, response) in
            if isSuccess {
                self.categoriesList = response as! [Category]
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate?.doneButtonTapped(type: FilterType.sozie, id: nil)
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
            vc.delegate = self
        }
    }
    
    
}


extension ListingPopupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: viewModel.reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
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
            var indexPathsToReload = [indexPath]
            if let previousSelectedIndex = selectedViewModelIndex {
                viewModels[previousSelectedIndex].isCheckmarkHidden = true
                indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
                selectedViewModelIndex = nil
                self.doneButton.isHidden = true
            } else {
                viewModels[indexPath.row].isCheckmarkHidden = false
                selectedViewModelIndex = indexPath.row
                self.doneButton.isHidden = false
            }
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)

            return
        }
        
        performSegue(withIdentifier: "toSubcategory", sender: self)
    }
    
}
extension ListingPopupVC : SelectionPopupVCDelegate {
    func doneButtonTapped(type: FilterType?, id: Int?) {
        delegate?.doneButtonTapped(type: type, id: id)
    }
}
