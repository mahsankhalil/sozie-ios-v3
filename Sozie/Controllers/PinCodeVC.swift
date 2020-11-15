//
//  PinCodeVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 8/13/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class PinCodeVC: UIViewController {

    @IBOutlet weak var securityCodeView: UIView!
    var signUpDict = [String: Any]()
    let pinCodeInputView: PinCodeInputView<UnderlineItemView> = .init(
        digit: 6,
        itemSpacing: 8,
        itemFactory: {
        return UnderlineItemView()
    })
    var pincode: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // initialize
        //        pinCodeInputView.frame.origin.x = 0.0
        //        pinCodeInputView.frame.origin.y = 0.0

                securityCodeView.addSubview(pinCodeInputView)
        pinCodeInputView.frame = CGRect(x: 0, y: 0, width: securityCodeView.bounds.width, height: securityCodeView.bounds.height)

                // set appearance
                pinCodeInputView.set(
                    appearance: .init(
                        itemSize: .init(width: 40, height: 68),
                        font: .systemFont(ofSize: 28, weight: .bold),
                        textColor: .black,
                        backgroundColor: .white,
                        cursorColor: .blue,
                        cornerRadius: 8
                    )
                )
//                pinCodeInputView.set(text: "123456")
                // text handling
                pinCodeInputView.set(changeTextHandler: { text in
                    self.pincode = text
                    print(text)
                })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        underLineItemView.frame.origin.x = 0.0
//        underLineItemView.frame.origin.y = 0.0
        pinCodeInputView.frame = CGRect(x: 0, y: 0, width: securityCodeView.bounds.width, height: securityCodeView.bounds.height)
        pinCodeInputView.keyboardType = .default
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if var signUpInfoProvider = segue.destination as? SignUpInfoProvider {
            signUpInfoProvider.signUpInfo = signUpDict
        }
    }
    @IBAction func confirmButtontapped(_ sender: Any) {
        if pincode?.count == 6 {
            var dataDict = [String: Any]()
            dataDict["code"] = pincode?.uppercased()
            SVProgressHUD.show()
            ServerManager.sharedInstance.verifySozieCode(params: dataDict) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    UserDefaultManager.saveSozieCode(code: self.pincode!.uppercased())  //Saving SozieCode
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.codeLinkedWith = (response as! CodeValidateRespose).linkedWith
                    self.signUpDict["signup_sozie_code"] = self.pincode?.uppercased()
                    let landingVC = self.storyboard?.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
                    landingVC.modalPresentationStyle = .fullScreen
                    landingVC.signUpInfo = self.signUpDict
                    self.present(landingVC, animated: true, completion: nil)
                } else {
                    let errorResponse = response as! Error
                    UtilityManager.showErrorMessage(body: errorResponse.localizedDescription, in: self)
                }
            }
        }
    }
    @IBAction func whatsThisButtonTapped(_ sender: Any) {
        UtilityManager.showMessageWith(title: "What is this?", body: "6 digit code is your unique code. Check your welcome email or ask the friend that referred you for this code.", in: self)
    }
}
