//
//  SearchBySizePopUpVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/27/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol SizeSelectionDelegate: class {
    func doneButtonTapped(selectedSizes: [String])
}

class SearchBySizePopUpVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var closeHandler: (() -> Void)?
    weak var delegate: SizeSelectionDelegate?
    var arrayOfSelectedIndexes: [Int] = []
    var viewModels: [DisclosureCellViewModel] = []
    var sizes: [String] = [] {
        didSet {
            viewModels.removeAll()
            for size in sizes {
                var viewModel = DisclosureCellViewModel()
                viewModel.title = size
                viewModel.reuseIdentifier = "TitleAndCheckmarkCell"
                viewModels.append(viewModel)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = UtilityManager.getGenderColor()
        fetchDataFromServer()
    }
    class func instance() -> SearchBySizePopUpVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let sizePopup = storyboard.instantiateViewController(withIdentifier: "SearchBySizePopUpVC") as! SearchBySizePopUpVC
        return sizePopup
    }

    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getSizeCharts(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                guard let size = response as? AllSizes else { return }
                if let gender = UserDefaultManager.getCurrentUserGender() {
                    if gender == "F" {
                        self.sizes = size.female?.sizes ?? []
                    } else {
                        self.sizes = size.male?.sizes ?? []
                    }
                } else {
                    self.sizes = size.female?.sizes ?? []
                }
                self.tableView.reloadData()
            } else {
                let err = response as? Error
                UtilityManager.showErrorMessage(body: err?.localizedDescription ?? "Something went wrong", in: self)
            }
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
    @IBAction func doneButtonTapped(_ sender: Any) {
        if arrayOfSelectedIndexes.count == 0 {
            return
        }
        var selectedSizes = [String]()
        for index in arrayOfSelectedIndexes {
            selectedSizes.append(sizes[index])
        }
        delegate?.doneButtonTapped(selectedSizes: selectedSizes)
        self.closeHandler!()

    }

}
extension SearchBySizePopUpVC: UITableViewDelegate, UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if arrayOfSelectedIndexes.contains(indexPath.row) {
            arrayOfSelectedIndexes.removeAll { $0 == indexPath.row }
            viewModels[indexPath.row].isCheckmarkHidden = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            arrayOfSelectedIndexes.append(indexPath.row)
            viewModels[indexPath.row].isCheckmarkHidden = false
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
extension SearchBySizePopUpVC: PopupContentViewController {
func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 350.0)
    }
}
