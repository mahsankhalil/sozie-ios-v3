//
//  CategoryPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

public enum FilterType: String {
    case category = "CATEGORY"
    case filter = "FILTER"
    case sozie = "SOZIE"
    case mySozies = "MYSOZIES"
    case request = "REQUESTS"
}

struct DisclosureCellViewModel: RowViewModel, ReuseIdentifierProviding, TitleViewModeling, CheckmarkViewModeling {
    var isCheckmarkHidden: Bool = true
    var title: String?
    var attributedTitle: NSAttributedString?
    var reuseIdentifier: String = "DisclosureCell"
}

protocol ListingPopupVCDelegate: class {
    func doneButtonTapped(type: FilterType?, objId: Int?)
}

class ListingPopupVC: UIViewController {
    weak var delegate: ListingPopupVCDelegate?
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var popupType: PopupType?
    var viewModels: [DisclosureCellViewModel] = []
    var brandList: [Brand]?
    var selectedCategory: Category?
    var filterType: FilterType?
    private var selectedViewModelIndex: Int?
    var selectedBrandId: Int?
    private var categoriesList: [Category] = [] {
        didSet {
            viewModels.removeAll()
            for category in categoriesList {
                var viewModel = DisclosureCellViewModel()
                viewModel.title = category.categoryName
                if category.subCategories.count == 0 {
                    viewModel.reuseIdentifier = "TitleAndCheckmarkCell"
                }
                viewModels.append(viewModel)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.layer.cornerRadius = 10.0

    }
    func setPopupType(type: PopupType?, brandList: [Brand]?, filterType: FilterType?) {
        if selectedViewModelIndex != nil {
            return
        }
        self.popupType = type
        self.brandList = brandList
        if let type = type {
            self.titleLabel.text = type.rawValue
        } else {
            self.titleLabel.text = "FILTER"
        }
        if popupType == PopupType.category {
            fetchCategoriesFromServer()
        } else {
            if let type = filterType {
                if type == FilterType.mySozies {
                    viewModels.removeAll()
                    var viewModel1 = DisclosureCellViewModel()
                    viewModel1.title = "SOZIES | FOLLOW"
                    viewModel1.reuseIdentifier = "TitleAndCheckmarkCell"
                    viewModels.append(viewModel1)
                    self.tableView.reloadData()
                } else if type == FilterType.request {
                    viewModels.removeAll()
                    var viewModel1 = DisclosureCellViewModel()
                    viewModel1.title = "FILLED REQUESTS"
                    viewModel1.reuseIdentifier = "TitleAndCheckmarkCell"
                    viewModels.append(viewModel1)
                    var viewModel2 = DisclosureCellViewModel()
                    viewModel2.title = "NEW REQUESTS"
                    viewModel2.reuseIdentifier = "TitleAndCheckmarkCell"
                    viewModels.append(viewModel2)
                    self.tableView.reloadData()
                }
            } else {
                if let userType = UserDefaultManager.getCurrentUserType() {
                    if userType == UserType.shopper.rawValue {
                        viewModels.removeAll()
                        var viewModel1 = DisclosureCellViewModel()
                        viewModel1.title = "FILTER BY BRANDS"
                        viewModels.append(viewModel1)
                    }
                }
                var viewModel2 = DisclosureCellViewModel()
                viewModel2.title = "FILTER BY SOZIES"
                viewModel2.reuseIdentifier = "TitleAndCheckmarkCell"
                viewModels.append(viewModel2)
                self.tableView.reloadData()
            }
        }
    }

    func fetchCategoriesFromServer() {
        ServerManager.sharedInstance.getAllCategories(params: [:]) { (isSuccess, response) in
            if isSuccess {
                self.categoriesList = response as! [Category]
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        if popupType == PopupType.category {
            if let index = selectedViewModelIndex {
                let currentCategory = categoriesList[index]
                delegate?.doneButtonTapped(type: FilterType.category, objId: currentCategory.categoryId)
            }
        } else {
            if let type = filterType {
                if let index = selectedViewModelIndex {
                    delegate?.doneButtonTapped(type: type, objId: index)
                }
            } else {
                delegate?.doneButtonTapped(type: FilterType.sozie, objId: nil)
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSubcategory" {
            let destVC = segue.destination as! SelectionPopupVC
            destVC.popupType = popupType
            destVC.selectedBrandId = selectedBrandId
            if popupType == PopupType.category {
                destVC.category = selectedCategory
            } else {
                destVC.brandList = brandList
            }
            destVC.delegate = self
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
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        }

        guard let cell = tableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }

    func reloadIndexPaths(indexPath: IndexPath, isDoneHidden: Bool) {
            var indexPathsToReload = [indexPath]
            if let previousSelectedIndex = selectedViewModelIndex {
                viewModels[previousSelectedIndex].isCheckmarkHidden = true
                indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
                if isDoneHidden {
                    if previousSelectedIndex == indexPath.row {
                        selectedViewModelIndex = nil
                        self.doneButton.isHidden = true
                    } else {
                        viewModels[indexPath.row].isCheckmarkHidden = false
                        selectedViewModelIndex = indexPath.row
                        self.doneButton.isHidden = false
                    }
                } else {
                    viewModels[indexPath.row].isCheckmarkHidden = false
                    selectedViewModelIndex = indexPath.row
                    self.doneButton.isHidden = false
                }
            } else {
                viewModels[indexPath.row].isCheckmarkHidden = false
                selectedViewModelIndex = indexPath.row
                self.doneButton.isHidden = false
            }
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if popupType == PopupType.category {
            let currentCategory = categoriesList[indexPath.row]
            if currentCategory.subCategories.count == 0 {
                reloadIndexPaths(indexPath: indexPath, isDoneHidden: false)
                return
            } else {
                selectedCategory = categoriesList[indexPath.row]
            }
        } else if filterType == FilterType.mySozies || filterType == FilterType.request {
            reloadIndexPaths(indexPath: indexPath, isDoneHidden: false)
            return
        } else if let userType = UserDefaultManager.getCurrentUserType() {
            if userType == UserType.sozie.rawValue {
                if indexPath.row == 0 {
                    reloadIndexPaths(indexPath: indexPath, isDoneHidden: false)
                    return
                }
            } else if indexPath.row == 1 {
                reloadIndexPaths(indexPath: indexPath, isDoneHidden: false)
                return
            }
        }

        performSegue(withIdentifier: "toSubcategory", sender: self)
    }

}
extension ListingPopupVC: SelectionPopupVCDelegate {

    func doneButtonTapped(type: FilterType?, objId: Int?) {
        delegate?.doneButtonTapped(type: type, objId: objId)
    }
}
