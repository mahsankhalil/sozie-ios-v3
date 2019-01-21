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
class SingleTextFieldCell: UITableViewCell, CustomPickerTextFieldDelegate {

    @IBOutlet weak var notSureBtn: UIButton!
    @IBOutlet weak var textField: CustomPickerTextField!
    var sizes: Size?
    var delegate : SingleTextFieldDelegate?
    var selectedHip : Int?
    var selectedWaist : Int?
    var currentMeasurement : LocalMeasurement?
    var measurementType : MeasurementType?
    var shouldValidate : Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.setupAppDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellData(cellType:MeasurementType) {
        switch cellType {
        case .waist:
    
            var values: [String] = []
            if let sizes = sizes {
                values = sizes.waist.convertArrayToString()
            }
            
            textField.configure(title: "WASIT", placeholder: "Wasit", values: values, valuesSuffix: "\"")
            
            if selectedWaist != nil {
                textField.text = String(describing: selectedWaist!)
            }

            if let waist = currentMeasurement?.waist {
                textField.text = waist
            } else {
                textField.text = ""
            }

        case .hips:
            var values: [String] = []
            if let sizes = sizes {
                values = sizes.hip.convertArrayToString()
            }
            textField.configure(title: "HIPS", placeholder: "Hips", values: values, valuesSuffix: "\"")
            
            if selectedHip != nil {
                textField.text = String(describing: selectedHip!)
            }

            if let hips = currentMeasurement?.hip {
                textField.text = hips
            } else {
                textField.text = ""
            }

        default: break
        }
        
        textField.pickerDelegate = self
        textField.isUserInteractionEnabled = !(sizes == nil)
    }
    
    func validateCellData() {
        if shouldValidate! {
            if measurementType == .waist {
                if currentMeasurement?.waist == nil {
                    textField.setError(CustomError(str: "Please Select Waist"), animated: true)
                } else {
                    textField.setError(nil, animated: true)
                }
            } else if measurementType == .hips {
                if currentMeasurement?.hip == nil {
                    textField.setError(CustomError(str: "Please Select Hip"), animated: true)
                } else {
                    textField.setError(nil, animated: true)
                }
            }
        }
    }
    
    func customPickerValueChanges(value1: String?, value2: String?) {
        textField.text = value1
        if measurementType == .waist {
            currentMeasurement?.waist = textField.text
        } else if measurementType == .hips {
            currentMeasurement?.hip = textField.text
        }
    }
    
    @IBAction func notSureBtnTapped(_ sender: Any) {
        delegate?.singleTextFieldNotSureBtnTapped!(btn: (sender as! UIButton) )
    }
    
}
