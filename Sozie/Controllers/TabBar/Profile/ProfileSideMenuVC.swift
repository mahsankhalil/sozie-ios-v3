//
//  ProfileSideMenuVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
struct TitleCellViewModel : RowViewModel, ReuseIdentifierProviding , TitleViewModeling {
    var title: String?
    var attributedTitle: NSAttributedString?
    let reuseIdentifier = "TitleCell"

}
//struct AboutSectionCellViewModel : RowViewModel, TitleViewModeling {
//    var title: String?
//    var attributedTitle: NSAttributedString?
//}
struct TitleCellWithSwitchViewModel : RowViewModel , SwitchProviding , TitleViewModeling , ReuseIdentifierProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var isSwitchOn : Bool?
    let reuseIdentifier = "TitleAndSwitchCell"
}


class ProfileSideMenuVC: BaseViewController {

    struct Section {
        var title: String
        var rowViewModels: [RowViewModel]
    }
    
    var sections: [Section] = []

    @IBOutlet weak var logoutBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    let accountTitles = ["Edit Profile" , "Update Profile Picture" , "Change Password" , "My Measurements"]
    let settingTitles = ["Push Notifications" , "Reset first-time use Guide" , "Blocked Accounts"]
    let aboutTitles = ["Invite Friends" , "Rate Sozie app" , "Send Feedback" , "Privacy Policy" , "Terms and Conditions of use"]
    private let titleCellReuseIdentifier = "TitleCell"
    private let titleAndSwitchCellReuseIdentifier = "TitleAndSwitchCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        func setupViewModels(_ titles: [String]) -> [RowViewModel] {
            var viewModels: [RowViewModel] = []
            for title in titles {
                var viewModel: RowViewModel
                if title == "Push Notifications" || title == "Reset first-time use Guide" {
                    viewModel = TitleCellWithSwitchViewModel(title: title, attributedTitle: nil, isSwitchOn: false)
                } else {
                    viewModel = TitleCellViewModel(title: title, attributedTitle: nil)
                }
                viewModels.append(viewModel)
            }
            return viewModels
        }
        
        let accountViewModels = setupViewModels(accountTitles)
        let accountSection = Section(title: "ACCOUNT", rowViewModels: accountViewModels)
        sections.append(accountSection)
        
        let settingViewModels = setupViewModels(settingTitles)
        let settingSection = Section(title: "SETTINGS", rowViewModels: settingViewModels)
        sections.append(settingSection)
        let aboutViewModels = setupViewModels(aboutTitles)
        let aboutSection = Section(title: "ABOUT", rowViewModels: aboutViewModels)
        sections.append(aboutSection)
    
        logoutBtn.cornerRadius = 0.0
    }
    

    func logout()
    {
        SVProgressHUD.show()
        var dataDict = [String : Any]()
        dataDict["refresh"] =  UserDefaultManager.getRefreshToken()
        ServerManager.sharedInstance.logoutUser(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            UserDefaultManager.deleteLoginResponse()
            self.changeRootVCToLoginNC()
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

    @IBAction func menuBtnTapped(_ sender: Any) {
    }
    @IBAction func logoutBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        let window = UIApplication.shared.keyWindow
        
        UtilityManager.showMessageWith(title: "Logout", body: "Are you sure you want to Log Out?", in: (window?.rootViewController)!, okBtnTitle: "Yes", cancelBtnTitle: "No") {
            self.logout()
        }
    

    }
}
extension ProfileSideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rowViewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
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
        lbl.text = sections[section].title
        lbl.textColor = UIColor.white
        headerVu.addSubview(lbl)
        return headerVu
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]
        let rowViewModel = section.rowViewModels[indexPath.row]
        
        var reuseIdentifier: String? = nil
        if let reuseIdentifierProvider = rowViewModel as? ReuseIdentifierProviding {
            reuseIdentifier = reuseIdentifierProvider.reuseIdentifier
        }
        
        guard let identifier = reuseIdentifier else { return UITableViewCell() }
        
        var tableViewcell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if tableViewcell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            tableViewcell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        
        guard let cell = tableViewcell else { return UITableViewCell() }
        
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch indexPath.row {
        case 0:
            let editProfileVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        default:
            return
            
        }
    }
    
}
