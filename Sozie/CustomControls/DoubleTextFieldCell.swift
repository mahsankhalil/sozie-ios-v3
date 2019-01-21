//
//  DoubleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
class DoubleTextFieldCell: UITableViewCell, CustomPickerTextFieldDelegate {

    @IBOutlet weak var secondTxtFld: CustomPickerTextField!
    @IBOutlet weak var firstTxtFld: CustomPickerTextField!
    var sizes : Size?
    var currentMeasurement : LocalMeasurement?
    var measurementType : MeasurementType?
    var shouldValidate : Bool?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstTxtFld.setupAppDesign()
        secondTxtFld.setupAppDesign()
    }

    func validateCellData() {
        if shouldValidate! {
            if measurementType == .braSize {
                if currentMeasurement?.bra == nil {
                    firstTxtFld.setError(CustomError(str: "Please Select Bra Size"), animated: true)
                } else {
                    firstTxtFld.setError(nil, animated: true)
                }
            } else if measurementType == .height {
                if currentMeasurement?.height == nil {
                    firstTxtFld.setError(CustomError(str: "Please Select Height"), animated: true)
                } else {
                    firstTxtFld.setError(nil, animated: true)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellData(cellType: MeasurementType) {
        switch cellType {
        case .height:
            var values1: [String] = []
            var values2: [String] = []
            if let sizes = sizes {
                values1 = sizes.height.feet.convertArrayToString()
                values2 = sizes.height.inches.convertArrayToString()
            }
            
            firstTxtFld.configure(title: "HEIGHT", rightTitle: "ft", placeholder: "Height", values1: values1, values1Suffix: "'", values2: values2, values2Suffix: "\"")
            
            secondTxtFld.configure(title: "HEIGHT", rightTitle: "in", placeholder: "", values1: values1, values1Suffix: "'", values2: values2, values2Suffix: "\"")
            
            if let height = currentMeasurement?.height {
                let inchValue = Int(Double(String(height.suffix(4)))! * 12.0)
                firstTxtFld.text = String(height.prefix(1))
                secondTxtFld.text = String(inchValue)
            } else {
                firstTxtFld.text = ""
                secondTxtFld.text = ""
            }

        case .braSize:
            
            var values1: [String] = []
            var values2: [String] = []
            if let sizes = sizes {
                values1 = sizes.bra.band.convertArrayToString()
                values2 = sizes.bra.cup
            }
            
            firstTxtFld.configure(title: "BRA SIZE", rightTitle: "band", placeholder: "Bra Size", values1: values1, values1Suffix: "", values2: values2, values2Suffix: "")
            
            secondTxtFld.configure(title: "BRA SIZE", rightTitle: "cup", placeholder: "", values1: values1, values1Suffix: "", values2: values2, values2Suffix: "")
            
            if let braSize = currentMeasurement?.bra {
                firstTxtFld.text = braSize
                secondTxtFld.text = currentMeasurement?.cup
            } else {
                firstTxtFld.text = ""
                secondTxtFld.text = ""
            }

        default: break
        }
        
        firstTxtFld.isUserInteractionEnabled = !(sizes == nil)
        secondTxtFld.isUserInteractionEnabled = !(sizes == nil)
        
        firstTxtFld.pickerDelegate = self
        secondTxtFld.pickerDelegate = self
    }
    
    func customPickerValueChanges(value1: String?, value2: String?) {
        firstTxtFld.text = value1
        secondTxtFld.text = value2
        
        if measurementType == .braSize {
            currentMeasurement?.bra = firstTxtFld.text
            currentMeasurement?.cup = secondTxtFld.text
        } else if measurementType == .height {
            let heightInches = (Double(secondTxtFld.text!)!)/12.0
            let str = String(format: "%0.4f", heightInches)
            currentMeasurement?.height = (firstTxtFld.text)! + str
        }
    }
}
