//
//  SingleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField

@objc protocol SingleTextFieldDelegate {
    @objc optional func singleTextFieldNotSureBtnTapped(btn : UIButton)
}
class SingleTextFieldCell: UITableViewCell , CustomPickerTextFieldDelegate {

    @IBOutlet weak var notSureBtn: UIButton!
    @IBOutlet weak var txtFld: CustomPickerTextField!
    var sizes : Size?
    var delegate : SingleTextFieldDelegate?
    var selectedHip : Int?
    var selectedWaist : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtFld.setupAppDesign()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellData(cellType:MeasurementType) {
        switch cellType {
        case .waist:
            
            txtFld.updateTxtFldWith(rightTitle: "", placeholder: "Waist", measurementType: Constant.single, values1: sizes?.waist.convertArrayToString(), values2: [], title: "WAIST", firsColumStr: "\"", secondColumnStr: "")
            if selectedWaist != nil
            {
                txtFld.text = String(describing: selectedWaist!)
            }

        case .hips:
            txtFld.updateTxtFldWith(rightTitle: "", placeholder: "Hips", measurementType: Constant.single, values1: sizes?.hip.convertArrayToString(), values2: [], title: "HIPS", firsColumStr: "\"", secondColumnStr: "")

            if selectedHip != nil
            {
                txtFld.text = String(describing: selectedHip!)
            }
        default: break
        }
        txtFld.pickerDelegate = self
        if sizes == nil
        {
            txtFld.isUserInteractionEnabled = false
        }
        else
        {
            txtFld.isUserInteractionEnabled = true
        }
    }
    
    func customPickerValueChanges(value1: String?, value2: String?) {
        txtFld.text = value1
    }
    
    
    @IBAction func notSureBtnTapped(_ sender: Any) {
        
        delegate?.singleTextFieldNotSureBtnTapped!(btn: (sender as! UIButton) )
    }
    
}
