//
//  TermsOfServiceVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/7/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
public enum TOSType: String {
    case privacyPolicy = "Privacy Policy"
    case termsCondition = "Terms and Conditions"
}
class TermsOfServiceVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var type: TOSType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let currentType = type {
            titleLabel.text = currentType.rawValue
        }
        populateText()
    }
    
    func populateText() {
        if let currentType = type {
            if currentType == .termsCondition {
                self.descriptionTextView.text = "COMMUNITY GUIDELINES \nSOZIE is a reflection of our diverse shapes, styles and fashion outlooks and is a place for us to find fashion inspiration and expression no matter what our shape or style is by connecting those who share (the same shape and style). We want SOZIE to be an authentic and safe place. By using SOZIE, you agree to these guidelines and our TERMS & CONDITIONS OF USE (see below). Overstepping these boundaries may result in deleted content, disabled accounts, or other restrictions. Help us foster this community. \nPOSTING\nPost only photos of your own fashion trials and looks. All other content is inappropriate on SOZIE.\nYou must accurately match product links to your photos of your fashion trials.\nPost only your own photos. You own the content you post on SOZIE. Remember to post authentic content, and don’t post anything you’ve copied or collected from the Internet that you don’t have the right to post.\nShare only photos that you’ve taken or have the right to share.\nWe don’t allow nudity or sexual content on SOZIE. This includes photos, videos, or digitally-created content that show genitals, fully-nude buttocks or female nipples. We have zero tolerance when it comes to sharing nudity or sexual content.\nGuard your privacy. You are allowed to mask your face or not include it when sharing any fashion looks or trials. You are encouraged to take this precaution if it is important to you to remain anonymous.\nGuard your identity. You may also use a username that does not reveal your identity. You are encouraged to take this precaution if it is important to you to remain anonymous.\nDon’t spam people\nDo not share photos or videos of children under the age of 14\nFoster meaningful and genuine interactions.\nRespect other members of the SOZIE community and maintain a supportive environment.\nAlways follow the law\nREPORTING\nIf you see something that you think may violate our guidelines, please help us by using our built-in reporting option. We have a team that reviews these reports and works as quickly as possible to remove content that doesn’t meet our guidelines. We may remove entire posts and suspend users based on reporting by users within our network.\nYou may find content you don’t like, but that doesn’t violate the Community Guidelines. If that happens, ( you can) we request you to block the person who posted it.\nWe may work with law enforcement agencies, including when we believe that there’s a risk of physical harm or a threat to public safety.\nThank you for helping us create the SOZIE community,\nTeam SOZIE\n\n\nTERMS & CONDITIONS OF USE\nYou must be at least 14 years old to use SOZIE.\nYou must comply with SOZIE’s Community Guidelines (see above).\nYou may not post violent, nude, partially nude, discriminatory, unlawful, infringing, hateful, pornographic or sexually suggestive photos or other content on or via SOZIE.\nYou are responsible for any activity that occurs through your account and you agree you will not sell, transfer, license or assign your account, or any account rights.\nYou agree that you will not create an account for anyone other than yourself.\nYou also represent that all information you provide or is provided to SOZIE for your account upon registration, and at all other times, will be true, accurate, current and complete..\nYou must not create accounts through unauthorized means, including but not limited to, by using an automated device, script, bot, spider, crawler or scraper.\nYou are responsible for keeping your password secret and secure.\nYou agree that you will not solicit, collect or use the login credentials of other SOZIE users.\nYou must not spam, defame, stalk, bully, abuse, harass, threaten, impersonate or intimidate other SOZIE users and you must not post private or confidential information via SOZIE, including, without limitation, your or any other person's credit card information, social security or alternate national identity numbers, non-public phone numbers or non-public email addresses.\nYou may not use SOZIE for any illegal or unauthorized purpose. You agree to comply with all laws, rules and regulations applicable to your use of SOZIE and your Content (defined below), including but not limited to, copyright laws.\nYou must not attempt to restrict another user from using or enjoying SOZIE and you must not encourage or facilitate violations of these Terms.\nYou must not interfere or disrupt SOZIE (or) servers or networks connected to SOZIE, including by transmitting any worms, viruses, spyware, malware or any other code of a destructive or disruptive nature.\nYou may not inject content or code, or otherwise alter or interfere with the way any SOZIE page is rendered or displayed in a user's browser or device.\nYou are solely responsible for your conduct and any data, information, usernames, images, graphics, photos, profiles, links and other content or materials (collectively, \"Content\") that you submit, post or display on or via SOZIE.\nYou represent and warrant that: (i) you own the Content posted by you on or through SOZIE; (ii) the posting and use of your Content on or through SOZIE does not violate, misappropriate or infringe on the rights of any third party, including, without limitation, privacy rights, publicity rights, copyrights, trademark and/or other intellectual property rights; (iii) you agree to pay for all royalties, fees, and any other monies owed by reason of Content you post on or through SOZIE; (iv) you have the legal right and capacity to enter into these Terms of Use in your jurisdiction; (v) you will never demand royalties or any other compensation from SOZIE due to the usage of any content you publish on or through SOZIE.\nYou agree that SOZIE is not responsible for, and does not endorse, Content posted within SOZIE. SOZIE does not have any obligation to pre-screen, monitor, edit, or remove any Content. If your Content violates these Terms of Use, you may bear legal responsibility for that Content.\nSOZIE does not claim ownership of any Content that you post on or through SOZIE. Instead, you hereby grant to SOZIE a non-exclusive, fully paid and royalty-free, transferable, sub-licensable, worldwide license to use the Content that you post on or through SOZIE.\nViolation of these Terms of Use may, in SOZIE's sole discretion, result in termination of your account. You understand and agree that SOZIE cannot and will not be responsible for the Content posted on SOZIE and you use SOZIE at your own risk. If you violate the letter or spirit of these Terms of Use, or otherwise create risk or possible legal exposure for SOZIE, we can stop providing all or part of SOZIE to you.\nWe reserve the right to modify or terminate (SOZIE or) your access to SOZIE for any reason, without notice, at any time, and without liability to you.\nYou can deactivate your account by emailing a deactivation request to theteam@sozie.com and we will deactivate your account as a matter of priority as soon as it is operationally feasible for us to do so. If we terminate your access to SOZIE or you deactivate your account, your photos, posts and all other data will no longer be accessible through your account, but those materials and data may persist and appear within SOZIE.\nWe may, but have no obligation to, remove, edit, block, and/or monitor Content or accounts containing Content that we determine in our sole discretion violates these Terms of Use.\nWe reserve the right, in our sole discretion, to change these Terms of Use (\"Updated Terms\") from time to time. The Updated Terms will be effective as of the time of posting, or such later date as may be specified in the Updated Terms, and will apply to your use of SOZIE from that point forward. These Terms of Use will govern any disputes arising before the effective date of the Updated Terms.\nYou are solely responsible for your interaction with other users of SOZIE, whether online or offline. You agree that SOZIE is not responsible or liable for the conduct of any user..\nThere may be links from SOZIE, or from communications you receive from SOZIE, to third-party web sites or features. There may also be links to third-party web sites or features in images within SOZIE. SOZIE also includes third-party content that we do not control, maintain or endorse. Functionality on SOZIE may also permit interactions between SOZIE and a third-party web site or feature.\nYour correspondence and business dealings with third parties found through SOZIE are solely between you and the third party.\nYou agree that you are responsible for all data charges you incur through use of SOZIE.\nThese terms and conditions are governed by and construed in accordance with the laws of England and Wales.\nThese Terms of Use were written in English (UK). To the extent any translated version of these Terms of Use conflicts with the English version, the English version controls.\nThe cases not covered herein will be decided by SOZIE under the guidance of the current EULA guidelines.\nThe effective date of these Terms of Use is March 15, 2018."
            } else {
                self.descriptionTextView.text = "GENERAL DATA PROTECTION REGULATION\nSOZIE is committed to maintaining the highest standards of security for its users’ data. It will therefore follow the most recent European standards for data protection: GDPR - General Data Protection Regulation, to be enforced after May 25th 2018. As part of those, our users can expect:\nNo data will be transferred from SOZIE to countries that do not hold equivalent protections as the one offered by SOZIE’s current jurisdiction.\nUsers will be able to revoke all data they have shared with the company through a request posed to theteam@sozie.com and SOZIE will remove it from its network and databases\nSOZIE will alert its customers within 3 days if any data breach is successfully conducted by any third-party\nUsers will be able to move all information shared in SOZIE to any other service provider, ceasing to be a member of SOZIE’s network  in the process\nUsers have the right to access, modify and limit processing of its information and to refuse being subjected to automated individual decision making\nFirewalls and file encryption will be put in place. Data will be backed-up and pseudonymised or otherwise encrypted to prevent reducibility.\nPrivacy by design and by default are the guidelines applied to all data management within SOZIE"
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
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
