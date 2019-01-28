//
//  ProfileSideMenuVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

struct AccountSectionCellViewModel : RowViewModel, TitleViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
}
struct AboutSectionCellViewModel : RowViewModel, TitleViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
}
struct SettingSectionCellViewModel : RowViewModel, TitleViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isSwitchOn : Bool?
}

class ProfileSideMenuVC: UIViewController {

    @IBOutlet weak var logoutBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    let titles = ["ACCOUNT","SETTINGS","ABOUT"]
    
    let accountTitles = ["Edit Profile" , "Update Profile Picture" , "Change Password" , "My Measurements"]
    let settingTitles = ["Push Notifications" , "Reset first-time use Guide" , "Blocked Accounts"]
    let aboutTitles = ["Invite Friends" , "Rate Sozie app" , "Send Feedback" , "Privacy Policy" , "Terms and Conditions of use"]
    private let titleCellReuseIdentifier = "TitleCell"
    private let titleAndSwitchCellReuseIdentifier = "TitleAndSwitchCell"

    private var accountViewModels : [AccountSectionCellViewModel] {
        get {
            var accTitles : [AccountSectionCellViewModel] = []
            
            for title in accountTitles {
                accTitles.append(AccountSectionCellViewModel(title: title, attributedTitle: nil))
            }
            return accTitles
        }
    }
    private var settingsViewModels : [SettingSectionCellViewModel] {
        get {
            var settTitles : [SettingSectionCellViewModel] = []
            
            for title in settingTitles {
                settTitles.append(SettingSectionCellViewModel(title: title, attributedTitle: nil , isSwitchOn : false))
            }
            return settTitles
        }
    }
    private var aboutViewModels : [AboutSectionCellViewModel] {
        get {
            var abtTitles : [AboutSectionCellViewModel] = []
            
            for title in settingTitles {
                abtTitles.append(AboutSectionCellViewModel(title: title, attributedTitle: nil))
            }
            return abtTitles
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoutBtn.cornerRadius = 0.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func menuBtnTapped(_ sender: Any) {
    }
    @IBAction func logoutBtnTapped(_ sender: Any) {
    }
}
extension ProfileSideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return accountViewModels.count
        case 1:
            return settingsViewModels.count
        case 2:
            return aboutViewModels.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 26.0
        }
        else
        {
            return 32.0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerVu = DZGradientView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: (self.tableView(tableView, heightForHeaderInSection: section))))
        let lbl = UILabel(frame: CGRect(x: 22.0, y: 0.0, width: tableView.frame.size.width - 22.0, height: (self.tableView(tableView, heightForHeaderInSection: section))))
        lbl.font = UIFont(name: "SegoeUI", size: 13.0)
        lbl.text = titles[section]
        lbl.textColor = UIColor.white
        headerVu.addSubview(lbl)
        return headerVu
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: titleCellReuseIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: titleCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: titleCellReuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier:titleCellReuseIdentifier)
        }
        
        var switchTableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: titleAndSwitchCellReuseIdentifier)
        
        if switchTableViewCell == nil {
            tableView.register(UINib(nibName: titleAndSwitchCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: titleAndSwitchCellReuseIdentifier)
            switchTableViewCell = tableView.dequeueReusableCell(withIdentifier:titleAndSwitchCellReuseIdentifier)
        }

        guard let cell = tableViewCell else { return UITableViewCell() }
        guard let switchCell = switchTableViewCell else { return UITableViewCell() }

        switch indexPath.section {
        case 0:
            let viewModel = accountViewModels[indexPath.row]
            if let cellConfigurable = cell as? CellConfigurable {
                cellConfigurable.setup(viewModel)
            }
        case 1:
            let viewModel = settingsViewModels[indexPath.row]
            if indexPath.row == 0 || indexPath.row == 1
            {
                if let cellConfigurable = switchCell as? CellConfigurable {
                    cellConfigurable.setup(viewModel)
                    switchCell.selectionStyle = .none
                    return switchCell
                }
            }
            else
            {
                if let cellConfigurable = cell as? CellConfigurable {
                    cellConfigurable.setup(viewModel)
                }
            }
            
        case 2:
            let viewModel = aboutViewModels[indexPath.row]
            if let cellConfigurable = cell as? CellConfigurable {
                cellConfigurable.setup(viewModel)
            }
            
        default:
            return cell
        }
        
        cell.selectionStyle = .none
        
        
        
//        let viewModel = viewModels[indexPath.row]
//        if let cellConfigurable = cell as? CellConfigurable {
//            cellConfigurable.setup(viewModel)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
//        guard let countries = countries else { return }
//
//        self.selectedCountryId = countries[indexPath.row].countryId
//
//        var indexPathsToReload = [indexPath]
//        if let previousSelectedIndex = selectedViewModelIndex {
//            viewModels[previousSelectedIndex].isCheckmarkHidden = true
//            indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
//        }
//
//        viewModels[indexPath.row].isCheckmarkHidden = false
//        selectedViewModelIndex = indexPath.row
//
//        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
}
