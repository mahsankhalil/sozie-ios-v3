//
//  ProfileSideMenuVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
import StoreKit
import SideMenu
import MessageUI
//import Intercom
struct TitleCellViewModel: RowViewModel, ReuseIdentifierProviding, TitleViewModeling, LineProviding {
    var isHidden: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
    let reuseIdentifier = "TitleCell"
}
struct HighLightedCellViewModel: RowViewModel, ReuseIdentifierProviding, TitleViewModeling, LineProviding {
    var isHidden: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
    let reuseIdentifier = "HighLightedCell"
}
//struct AboutSectionCellViewModel : RowViewModel, TitleViewModeling {
//    var title: String?
//    var attributedTitle: NSAttributedString?
//}
struct TitleCellWithSwitchViewModel: RowViewModel, SwitchProviding, TitleViewModeling, ReuseIdentifierProviding, LineProviding {
    var isHidden: Bool
    var title: String?
    var attributedTitle: NSAttributedString?
    var isSwitchOn: Bool?
    let reuseIdentifier = "TitleAndSwitchCell"
}

class ProfileSideMenuVC: BaseViewController {

    struct Section {
        var title: String
        var rowViewModels: [RowViewModel]
    }
    var sections: [Section] = []

    @IBOutlet weak var myBalanceButton: UIButton!
    @IBOutlet weak var myBalanceGradientView: DZGradientView!
    @IBOutlet weak var myBalanceViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var myBalanceView: UIView!
    @IBOutlet weak var logoutBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var howToTakePicturesButton: UIButton!
    var accountTitles = ["Edit Profile", "Update Profile Picture", "Change Password", "My Measurements"]
    let settingTitles = ["Push Notifications", "Blocked Accounts"]
    var aboutTitles = ["Invite Friends", "Rate Sozie app", "Send Feedback", "Privacy Policy", "Terms and Conditions"]
    private let titleCellReuseIdentifier = "TitleCell"
    private let titleAndSwitchCellReuseIdentifier = "TitleAndSwitchCell"
    private let higlightedCellReuseIdentifier = "HighLightedCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let sozieType = UserDefaultManager.getCurrentSozieType(), sozieType == "BS" {
            myBalanceViewHeightContraint.constant = 0.0
            aboutTitles = ["Rate Sozie app", "Send Feedback", "Privacy Policy", "Terms and Conditions"]
        } else {
            self.myBalanceViewHeightContraint.constant = 50.0
        }
        self.tblVu.backgroundColor = UIColor.white
//        if UserDefaultManager.getIfShopper() {
//            self.myBalanceViewHeightContraint.constant = 0.0
//        } else {
//            self.myBalanceViewHeightContraint.constant = 50.0
////            accountTitles = ["Edit Profile", "Update Profile Picture", "Change Password", "My Measurements", "Change My Workplace"]
//        }
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

    func setupViewModels(_ titles: [String]) -> [RowViewModel] {
        var viewModels: [RowViewModel] = []
        var index = 0
        for title in titles {
            var viewModel: RowViewModel
            var bottomLineHidden = false
            if index == titles.count - 1 {
                bottomLineHidden = true
            }
            if title == "Push Notifications" || title == "Reset Tutorial" {
                var flag = false
                if title == "Push Notifications" {
                    if let user = UserDefaultManager.getCurrentUserObject() {
                        if let notfStatus = user.preferences?.pushNotificationEnabled {
                            flag = notfStatus
                        }
                    }
                } else if title == "Reset Tutorial" {
                    flag = false
//                    flag = !UserDefaultManager.isUserGuideDisabled()
                }
                viewModel = TitleCellWithSwitchViewModel(isHidden: bottomLineHidden, title: title, attributedTitle: nil, isSwitchOn: flag)
                            } else {
                if title == "My Measurements" && UserDefaultManager.checkIfMeasurementEmpty() {
                    viewModel = HighLightedCellViewModel(isHidden: bottomLineHidden, title: title, attributedTitle: nil)
                } else {
                    viewModel = TitleCellViewModel(isHidden: bottomLineHidden, title: title, attributedTitle: nil)
                }
            }
            viewModels.append(viewModel)
            index = index + 1
        }
        return viewModels
    }
    func logout() {
        SVProgressHUD.show()
        var dataDict = [String: Any]()
        dataDict["refresh"] =  UserDefaultManager.getRefreshToken()
        ServerManager.sharedInstance.logoutUser(params: dataDict) { (_, _) in
            SVProgressHUD.dismiss()
            UserDefaultManager.deleteLoginResponse()
            UserDefaultManager.makeUserGuideEnable()
            UserDefaultManager.removeAllUserGuidesShown()
            UserDefaultManager.deleteBrowserTutorialShown()
            UserDefaultManager.deleteRequestTutorialShown()
            Intercom.logout()
            Intercom.setLauncherVisible(false)
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
    func rateThisApp() {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1363346896?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    func showInviteFriendsVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let inviteVC = storyBoard.instantiateViewController(withIdentifier: "InviteFriendsVC") as! InviteFriendsVC
        inviteVC.isFromSideMenu = true
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    func showUploadPhotoVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let inviteVC = storyBoard.instantiateViewController(withIdentifier: "UploadProfilePictureVC") as! UploadProfilePictureVC
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    func showChangePasswordVC() {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let inviteVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    func sendFeedbackWithEmail() {
//        let composeVC = MFMailComposeViewController()
//        composeVC.mailComposeDelegate = self
//        // Configure the fields of the interface.
//        composeVC.setToRecipients(["theteam@sozie.com"])
//        composeVC.setSubject("Feedback")
//        // Present the view controller modally.
//        self.present(composeVC, animated: true, completion: nil)
        let email = "theteam@sozie.com"
        if let url = URL(string: "mailto:\(email)?subject=Feedback") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    func showMeasurementVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let measurementVC = storyBoard.instantiateViewController(withIdentifier: "MeasurementsVC") as! MeasurementsVC
        self.navigationController?.pushViewController(measurementVC, animated: true)

    }
    func showBlockedListVC() {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let inviteVC = storyBoard.instantiateViewController(withIdentifier: "BlockListVC") as! BlockListVC
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
    func showUpdateWorkPlaceVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let measurementVC = storyBoard.instantiateViewController(withIdentifier: "SelectWorkVC") as! SelectWorkVC
        self.navigationController?.pushViewController(measurementVC, animated: true)
    }
    func showEditProfileVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let editProfileVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    func showTOSVC(type: TOSType) {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let tosVC = storyBoard.instantiateViewController(withIdentifier: "TermsOfServiceVC") as! TermsOfServiceVC
        tosVC.type = type
        self.navigationController?.pushViewController(tosVC, animated: true)
    }
    func showTermsAndConditionsVC() {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func menuBtnTapped(_ sender: Any) {

    }
    @IBAction func myBalanceButtonTapped(_ sender: Any) {
        if let sozieType = UserDefaultManager.getCurrentSozieType(), sozieType == "BS" {
            UtilityManager.showMessageWith(title: "My Balance", body: "Currently you do not have access of My Balance. Please ask your manager.", in: self)
        } else {
            let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
            let balanceVC = storyBoard.instantiateViewController(withIdentifier: "MyBalanceVC") as! MyBalanceVC
            self.navigationController?.pushViewController(balanceVC, animated: true)
        }
    }
    @IBAction func howToTakeSoziePicturesButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ShowInstructions")))
        self.dismiss(animated: true, completion: nil)
//        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
//        let instructionVC = storyBoard.instantiateViewController(withIdentifier: "SozieInstructionsVC") as! SozieInstructionsVC
//        self.navigationController?.pushViewController(instructionVC, animated: true)
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
        if section == 0 {
            return 26.0
        } else {
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
        var reuseIdentifier: String?
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
        if let buttonProvidingCell = cell as? ButtonProviding {
            buttonProvidingCell.assignTagWith(indexPath.row)
        }
        if let switchCell = cell as? TitleAndSwitchCell {
            switchCell.delegate = self
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            performSectionOneActions(row: indexPath.row)
        case 1:
            performSectionTwoActions(row: indexPath.row)
        case 2:
            performSectionThreeActions(row: indexPath.row)
        default:
            return
        }
    }
    func performSectionOneActions(row: Int) {
        switch row {
        case 0:
            showEditProfileVC()
        case 1:
            showUploadPhotoVC()
        case 2:
            showChangePasswordVC()
        case 3:
            showMeasurementVC()
        case 4:
            showUpdateWorkPlaceVC()
        default:
            return
        }
    }
    func performSectionTwoActions(row: Int) {
        switch row {
        case 1:
            showBlockedListVC()
        default:
            return
        }
    }
    func performSectionThreeActions(row: Int) {
        if let sozieType = UserDefaultManager.getCurrentSozieType(), sozieType == "BS" {
            switch row {
            case 0:
                rateThisApp()
            case 1:
                sendFeedbackWithEmail()
            case 2:
                showTOSVC(type: TOSType.privacyPolicy)
            case 3:
                showTermsAndConditionsVC()
    //            showTOSVC(type: TOSType.termsCondition)
            default:
                return
            }
        } else {
            switch row {
            case 0:
                showInviteFriendsVC()
            case 1:
                rateThisApp()
            case 2:
                sendFeedbackWithEmail()
            case 3:
                showTOSVC(type: TOSType.privacyPolicy)
            case 4:
                showTermsAndConditionsVC()
    //            showTOSVC(type: TOSType.termsCondition)
            default:
                return
            }
        }
    }

}
extension ProfileSideMenuVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension ProfileSideMenuVC: TitleAndSwitchCellDelegate {
    func switchValueChanged(switchButton: UISwitch) {
        if switchButton.tag == 0 {
            var dataDict = [String: Any]()
            dataDict["enable_notifications"] = switchButton.isOn
            ServerManager.sharedInstance.updatePrefernce(params: dataDict) { (isSuccess, response) in
                if isSuccess {
                    if var currentUser = UserDefaultManager.getCurrentUserObject() {
                        if currentUser.preferences != nil {
                            currentUser.preferences?.pushNotificationEnabled = switchButton.isOn
                            UserDefaultManager.updateUserObject(user: currentUser)
                        }
                    }
                } else {
                    UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
                }
            }
        } else {
            if switchButton.isOn {
                UserDefaultManager.makeUserGuideEnable()
                UserDefaultManager.removeAllUserGuidesShown()
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ResetFirstTime")))

            } else {
                UserDefaultManager.makeUserGuideDisabled()
                UserDefaultManager.markAllUserGuidesNotShown()
            }
        }
    }
}
