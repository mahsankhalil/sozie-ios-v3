//
//  UploadProfilePictureVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 12/26/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class UploadProfilePictureVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var uploadBtn: DZGradientButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var imgVu: UIImageView!
    var pickedImage: UIImage?
    var isFromSignUp = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgVu.applyCornerRadiusAndBorder()
        if isFromSignUp {
            skipBtn.isHidden = false
            backBtn.isHidden = true
        } else {
            if let currentUser = UserDefaultManager.getCurrentUserObject() {
                if let picture = currentUser.picture {
                    imgVu.sd_setImage(with: URL(string: picture), completed: nil)
                }
                skipBtn.isHidden = true
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
    // MARK: - Image Picker Delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickdImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = pickdImg
            imgVu.image = pickdImg
            imgVu.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: - Actions
    @IBAction func addBtnTapped(_ sender: Any) {
        UtilityManager.openImagePickerActionSheetFrom(viewController: self)
    }

    @IBAction func uploadBtnTapped(_ sender: Any) {
        if pickedImage != nil {
            if let scaledImg = pickedImage?.scaleImageToSize(newSize: CGSize(width: 750, height: ((pickedImage?.size.height)!/(pickedImage?.size.width)!)*750)) {
                let imgData = scaledImg.jpegData(compressionQuality: 0.1)
                SVProgressHUD.show()
                ServerManager.sharedInstance.updateProfile(params: nil, imageData: imgData) { (isSuccess, response) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        let user = response as! User
                        UserDefaultManager.updateUserObject(user: user)
                        if self.isFromSignUp {
                            self.performSegue(withIdentifier: "toInviteFriends", sender: self)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        let error = response as! Error
                        UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                    }
                }
            }
        } else {
            UtilityManager.showErrorMessage(body: "Please select Image", in: self)
        }
    }

    @IBAction func skipBtnTapped(_ sender: Any) {
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        if isFromSignUp == false {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
