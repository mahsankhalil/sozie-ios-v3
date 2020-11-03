//
//  TermsAndConditionsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/27/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModels: [TermsConditionViewModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let termsAndConditionViewModel = TermsConditionViewModel(title: "Terms and Conditions", attributedTitle: nil, subtitle: "•You must be at least 14 years old\n\n • You must comply with our Community Guidelines\n\n • You may not post violent, nude, partially nude, discriminatory, unlawful, infringing, hateful, pornographic or sexually suggestive content\n\n • You are responsible for any activity that occurs through your account and you agree you will not sell, transfer, license or assign your account, or any account rights.\n\n • You agree that you will not create an account for anyone other than yourself.\n\n • You also represent that all information you provide or is provided to Sozie for your account upon registration, and at all other times, will be true, accurate, current and complete.\n\n • You must not create accounts through unauthorized means, including but not limited to, by using an automated device, script, bot, spider, crawler or scraper.\n\n • You are responsible for keeping your password secret and secure.\n\n • You agree that you will not solicit, collect or use the login credentials of other users.\n\n • You must not spam, defame, stalk, bully, abuse, harass, threaten, impersonate or intimidate other users \n\n • You must not post private or confidential information , including, without limitation, your or any other person's credit card information, social security or alternate national identity numbers, non-public phone numbers or non-public email addresses\n\n • You may not use Sozie for any illegal or unauthorised purpose\n\n • You agree to comply with all laws, rules and regulations applicable to your use of Sozie and your Content (defined below), including but not limited to, copyright laws\n\n • You must not attempt to restrict another user from using or enjoying Sozie and you must not encourage or facilitate violations of these Terms\n\n • You must not interfere or disrupt Sozie (or) servers or networks connected to SOZIE, including by transmitting any worms, viruses, spyware, malware or any other code of a destructive or disruptive nature.\n\n • You may not inject content or code, or otherwise alter or interfere with the way any Sozie page is rendered or displayed in a user's browser or device.\n\n • You are solely responsible for your conduct and any data, information, usernames, images, graphics, photos, profiles, links and other content or materials (collectively, \"Content\") that you submit, post or display on or via Sozie.\n\n • You represent and warrant that:\n\n  (i) you own the Content posted by you on or through Sozie;\n\n  (ii) the posting and use of your Content on or through Sozie does not violate, misappropriate or infringe on the rights of any third party, including, without limitation, privacy rights, publicity rights, copyrights, trademark and/or other intellectual property rights;\n\n  (iii) you agree to pay for all royalties, fees, and any other monies owed by reason of Content you post on or through Sozie;\n\n  (iv) you have the legal right and capacity to enter into these Terms of Use in your jurisdiction;\n\n  (v) you will never demand royalties or any other compensation from Sozie due to the usage of any content you publish on or through Sozie\n\n • You agree that Sozie is not responsible for, and does not endorse, Content posted within SOZIE.\n\n • Sozie does not have any obligation to pre-screen, monitor, edit, or remove any Content. If your Content violates these Terms of Use, you may bear legal responsibility for that Content.\n\n • Sozie does not claim ownership of any Content that you post on or through SOZIE. Instead, you hereby grant to SOZIE a non-exclusive, fully paid and royalty-free, transferable, sub-licensable, worldwide and indefinite license to use the Content that you post on or through Sozie.\n\n • Violation of these Terms of Use may, in our sole discretion, result in termination of your account\n\n • You understand and agree that Sozie cannot and will not be responsible for the Content posted on Sozie and you use Sozie at your own risk.\n\n • If you violate the letter or spirit of these Terms of Use, or otherwise create risk or possible legal exposure for Sozie, we can stop providing all or part of Sozie to you.\n\n • We reserve the right to modify or terminate your access to Sozie for any reason, without notice, at any time, and without liability to you.\n\n • You can deactivate your account by emailing a deactivation request to theteam@sozie.com and we will deactivate your account. Please refer to our privacy policy for more details. \n\n • We may, but have no obligation to, remove, edit, block, and/or monitor Content or accounts containing Content that we determine in our sole discretion violates these Terms of Use.\n\n • We reserve the right, in our sole discretion, to change these Terms of Use (\"Updated Terms\") from time to time. The Updated Terms will be effective as of the time of posting, or such later date as may be specified in the Updated Terms, and will apply to your use of Sozie from that point forward.\n\n • These Terms of Use will govern any disputes arising before the effective date of the Updated Terms.\n\n • You are solely responsible for your interaction with other users of Sozie, whether online or offline. You agree that Sozie is not responsible or liable for the conduct of any user.\n\n • There may be links from Sozie, or from communications you receive from Sozie, to third-party web sites or features. There may also be links to third-party web sites or features in images within Sozie. Sozie also includes third-party content that we do not control, maintain or endorse. Functionality on Sozie may also permit interactions between Sozie and a third-party web site or feature. Your correspondence and business dealings with third parties found through SOZIE are solely between you and the third party.\n\n • You agree that you are responsible for all data charges you incur through use of SOZIE.\n\n • These terms and conditions are governed by and construed in accordance with the laws of England and Wales.\n\n • These Terms of Use were written in English (UK). To the extent any translated version of these Terms of Use conflicts with the English version, the English version controls.\n\n • The cases not covered herein will be decided by Sozie under the current EULA guidelines\n\n • The effective date of these Terms of Use is March 15, 2018", isAvailable: false)
        let communityGuideLinesViewModel = TermsConditionViewModel(title: "Community Guidelines", attributedTitle: nil, subtitle: "Sozie is a reflection of our desire to see ourselves represented in fashion. We believe people crave connection with real human beings and are inspired by their diverse looks and styles and authentic views on products. We are on mission to drive sales online through inclusion.\n\nBy using Sozie, you agree to following these community guidelines. Overstepping these boundaries may result in restrictions on your account. Help us foster this community.\n\n\nPOSTING\n\n • Post only your own content. You own the content you post on Sozie. Remember to post authentic content, and don’t post anything you’ve copied or collected from the Internet that you don’t have the right to post.\n\n • Post content only of product trials and looks. All other content is inappropriate on Sozie.\n\n • Accurately link your content to products when accepting requests.\n\n • We don’t allow nudity or sexual content on Sozie. This includes photos, videos, or digitally-created content that show genitals, fully-nude buttocks or female nipples. We have zero tolerance when it comes to sharing nudity or sexual content.\n\n • Guard your identity. You may use a username that does not reveal your identity. You are encouraged to take this precaution if it is important to you to remain anonymous.\n\n • Do not post content if you are under the age of 14\n\n • Respect other members of the Sozie community and maintain a supportive environment\n\n • Be mindful of others and maintain your own physical safety in all environments you choose  to create content\n\n • Always follow the law\n\nREPORTING\n\n • If you see a post that you think might violate our community guidelines, please help us by using our built-in reporting option.\n\n • We have a team that reviews these reports and works as quickly as possible to remove content that doesn’t meet our guidelines. We may remove entire posts and suspend users based on reporting by users within our network.\n\n • You may find content you don’t like, but that doesn’t violate the Community Guidelines. If that happens, we request you to block the person who posted it.\n\n • We may work with law enforcement agencies, including when we believe that there’s a risk of physical harm or a threat to public safety.\n\nThank you for being a part of the Sozie Community! Have fun and stay safe!", isAvailable: false)
        viewModels.append(termsAndConditionViewModel)
        viewModels.append(communityGuideLinesViewModel)
        tableView.tableFooterView = UIView()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        if let navContrlr = self.navigationController {
            navContrlr.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
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

}
extension TermsAndConditionsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "TermsConditionCell")
        if tableViewCell == nil {
            tableView.register(UINib(nibName: "TermsConditionCell", bundle: nil), forCellReuseIdentifier: "TermsConditionCell")
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TermsConditionCell")
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModels[indexPath.row].isAvailable = !viewModels[indexPath.row].isAvailable
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
