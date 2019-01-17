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
    
    var currentMeasurement : LocalMeasurement?
    var measurementType : MeasurementType?
    var shouldValidate : Bool?
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
            if let waist = currentMeasurement?.waist
            {
                txtFld.text = waist
            }
            else
            {
                txtFld.text = ""
            }

        case .hips:
            txtFld.updateTxtFldWith(rightTitle: "", placeholder: "Hips", measurementType: Constant.single, values1: sizes?.hip.convertArrayToString(), values2: [], title: "HIPS", firsColumStr: "\"", secondColumnStr: "")

            if selectedHip != nil
            {
                txtFld.text = String(describing: selectedHip!)
            }
            if let hips = currentMeasurement?.hip
            {
                txtFld.text = hips
            }
            else
            {
                txtFld.text = ""
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
    
    func validateCellData()
    {
        if shouldValidate!
        {
            if measurementType == .waist
            {
                if currentMeasurement?.waist == nil
                {
                    txtFld.setError(CustomError(str: "Please Select Waist"), animated: true)
                }
                else
                {
                    txtFld.setError(nil, animated: true)
                }
            }
            else if measurementType == .hips
            {
                if currentMeasurement?.hip == nil
                {
                    txtFld.setError(CustomError(str: "Please Select Hip"), animated: true)
                }
                else
                {
                    txtFld.setError(nil, animated: true)
                }
            }
        }
        
    }
    
    func customPickerValueChanges(value1: String?, value2: String?) {
        txtFld.text = value1
        if measurementType == .waist
        {
            currentMeasurement?.waist = txtFld.text
        }
        else if measurementType == .hips
        {
            currentMeasurement?.hip = txtFld.text
        }
    }
    
    
    @IBAction func notSureBtnTapped(_ sender: Any) {
        
        delegate?.singleTextFieldNotSureBtnTapped!(btn: (sender as! UIButton) )
    }
    
}
