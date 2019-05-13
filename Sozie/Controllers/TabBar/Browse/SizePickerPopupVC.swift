//
//  SizePickerPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

class SizePickerPopupVC: UIViewController {

    @IBOutlet weak var selectButton: DZGradientButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    var productSizeChart: [ProductSize]?
    weak var delegate: RequestSizeChartPopupVCDelegate?
    var closeHandler: (() -> Void)?
    var currentProductId: String?
    var currentBrandId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.delegate == nil {
            titleLabel.text = "What size would you like to request a picture of?"
        } else {
            titleLabel.text = "What size are you wearing?"
        }
    }
    static func instance(productSizeChart: [ProductSize]?, currentProductId: String? = nil, brandid: Int? = nil) -> SizePickerPopupVC {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "SizePickerPopupVC") as! SizePickerPopupVC
        instnce.productSizeChart = productSizeChart
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
        instnce.currentProductId = currentProductId
        instnce.currentBrandId = brandid
        return instnce
    }
    @IBAction func selectButtonTapped(_ sender: Any) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if let popupDelegate = delegate {
            popupDelegate.selectedValueFromPopUp(value: productSizeChart?[selectedRow].name ?? "")
            closeHandler?()
            return
        }
        makePostRequestToServer()
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        closeHandler?()
    }

    func makePostRequestToServer() {
        var dataDict = [String: Any]()
        let index = pickerView.selectedRow(inComponent: 0)
        dataDict["size_worn"] = productSizeChart?[index].name
        dataDict["product_id"] = currentProductId
        dataDict["brand"] = currentBrandId
        SVProgressHUD.show()
        ServerManager.sharedInstance.makePostRequest(params: dataDict) { [weak self] (isSuccess, response) in
            SVProgressHUD.dismiss()
            guard let self = self else {
                return
            }
            if isSuccess {
                self.closeHandler?()
            } else {
                let error = response as! Error
                UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
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

}
extension SizePickerPopupVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productSizeChart?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return productSizeChart?[row].name
    }
}
extension SizePickerPopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        popupController.popupView.layer.cornerRadius = 10.0
        popupController.popupView.clipsToBounds = true
        return CGSize(width: UIScreen.main.bounds.size.width, height: 380)
    }
}
