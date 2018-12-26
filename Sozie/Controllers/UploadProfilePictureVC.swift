//
//  UploadProfilePictureVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 12/26/18.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class UploadProfilePictureVC: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var uploadBtn: DZGradientButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var imgVu: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imgVu.applyCornerRadiusAndBorder()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imgVu.image = pickedImage
            imgVu.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK : - Actions
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
        UtilityManager.openImagePickerActionSheetFrom(vc: self)
        
    }
    @IBAction func uploadBtnTapped(_ sender: Any) {
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
