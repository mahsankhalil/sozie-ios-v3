//
//  SelectionPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SelectionPopupVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tblVu: UITableView!
    private var selectedViewModelIndex: Int?

    var popupType: PopupType?

    var category : Category? = nil {
        didSet {
            viewModels.removeAll()
            for subCategory in (category?.subCategories)! {
                let viewModel = BrandCellViewModel(title: subCategory.subCategoryName, attributedTitle: nil, isCheckmarkHidden: true)
                viewModels.append(viewModel)
            }
        }
    }
    
//    var subcategories : [SubCategory]? = [] {
//        didSet {
//            viewModels.removeAll()
//            for subCategory in subcategories! {
//                let viewModel = BrandCellViewModel(title: subCategory.subCategoryName, attributedTitle: nil, isCheckmarkHidden: true)
//                viewModels.append(viewModel)
//                self.tblVu.reloadData()
//            }
//        }
//    }
    var brandList: [Brand]? = [] {
        didSet {
            viewModels.removeAll()
            for brand in brandList! {
                let viewModel = BrandCellViewModel(title: brand.label, attributedTitle: nil, isCheckmarkHidden: true)
                viewModels.append(viewModel)
            }
        }
    }
    private var viewModels: [BrandCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.layer.cornerRadius = 10.0
        
//        titleLbl.text = popupType?.rawValue
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if popupType == PopupType.category {
            titleLbl.text = category?.categoryName
        } else {
            titleLbl.text = "BRANDS"
        }
        self.tblVu.reloadData()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneBtnTapped(_ sender: Any) {
    }
    
}

extension SelectionPopupVC: UITableViewDelegate, UITableViewDataSource {
    
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
