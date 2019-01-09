//
//  SingleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
class SingleTextFieldCell: UITableViewCell , CustomPickerTextFieldDelegate {

    @IBOutlet weak var notSureBtn: UIButton!
    @IBOutlet weak var txtFld: CustomPickerTextField!
    var sizeChart : SizeChart?
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
            
            txtFld.updateTxtFldWith(rightTitle: "", placeholder: "Waist", measurementType: Constant.single, values1: sizeChart?.waist.convertArrayToString(), values2: [], title: "WAIST", firsColumStr: "\"", secondColumnStr: "")

        case .hips:
            txtFld.updateTxtFldWith(rightTitle: "", placeholder: "Hips", measurementType: Constant.single, values1: sizeChart?.hip.convertArrayToString(), values2: [], title: "HIPS", firsColumStr: "\"", secondColumnStr: "")


        default: break
        }
        txtFld.pickerDelegate = self
        if sizeChart == nil
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
    
    
    
}
