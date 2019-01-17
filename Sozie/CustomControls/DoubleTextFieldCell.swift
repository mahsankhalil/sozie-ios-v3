//
//  DoubleTextFieldCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/9/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
class DoubleTextFieldCell: UITableViewCell , CustomPickerTextFieldDelegate {

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

    func validateCellData()
    {
        if shouldValidate!
        {
            if measurementType == .braSize
            {
                if currentMeasurement?.bra == nil
                {
                    firstTxtFld.setError(CustomError(str: "Please Select Bra Size"), animated: true)
                }
                else
                {
                    firstTxtFld.setError(nil, animated: true)
                }
            }
            else if measurementType == .height
            {
                if currentMeasurement?.height == nil
                {
                    firstTxtFld.setError(CustomError(str: "Please Select Height"), animated: true)
                }
                else
                {
                    firstTxtFld.setError(nil, animated: true)
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellData(cellType:MeasurementType) {
        switch cellType {
        case .height:
            firstTxtFld.updateTxtFldWith(rightTitle: "ft", placeholder: "Height", measurementType: Constant.double, values1: sizes?.height.feet.convertArrayToString(), values2: sizes?.height.inches.convertArrayToString(), title: "HEIGHT", firsColumStr: "'", secondColumnStr: "\"")

            
            secondTxtFld.updateTxtFldWith(rightTitle: "in", placeholder: "", measurementType: Constant.double, values1: sizes?.height.feet.convertArrayToString(), values2: sizes?.height.inches.convertArrayToString(), title: "HEIGHT", firsColumStr: "'", secondColumnStr: "\"")
            
            if let height = currentMeasurement?.height
            {
                let inchValue = Int(Double(String(height.suffix(4)))! * 12.0)
                
                
                firstTxtFld.text = String(height.prefix(1))
                secondTxtFld.text = String(inchValue)
            }
            else
            {
                firstTxtFld.text = ""
                secondTxtFld.text = ""
                
            }

        case .braSize:
            
            firstTxtFld.updateTxtFldWith(rightTitle: "band", placeholder: "Bra Size", measurementType: Constant.double, values1: sizes?.bra.band.convertArrayToString(), values2: sizes?.bra.cup, title: "BRA SIZE", firsColumStr: "", secondColumnStr: "")
            

            secondTxtFld.updateTxtFldWith(rightTitle: "cup", placeholder: "", measurementType: Constant.double, values1: sizes?.bra.band.convertArrayToString(), values2: sizes?.bra.cup, title: "BRA SIZE", firsColumStr: "", secondColumnStr: "")
            
            if let braSize = currentMeasurement?.bra
            {
                firstTxtFld.text = braSize
                secondTxtFld.text = currentMeasurement?.cup
            }
            else
            {
                firstTxtFld.text = ""
                secondTxtFld.text = ""
                
            }

        default: break
        }
        if sizes == nil
        {
            firstTxtFld.isUserInteractionEnabled = false
            secondTxtFld.isUserInteractionEnabled = false
        }
        else
        {
            firstTxtFld.isUserInteractionEnabled = true
            secondTxtFld.isUserInteractionEnabled = true
        }
        firstTxtFld.pickerDelegate = self
        secondTxtFld.pickerDelegate = self
    }
    func customPickerValueChanges(value1: String?, value2: String?) {
        firstTxtFld.text = value1
        secondTxtFld.text = value2
        
        if measurementType == .braSize
        {
            currentMeasurement?.bra = firstTxtFld.text
            currentMeasurement?.cup = secondTxtFld.text
        }
        else if measurementType == .height
        {
            let heightInches = (Double(secondTxtFld.text!)!)/12.0
            let str = String(format: "%0.4f", heightInches)
            
            currentMeasurement?.height = (firstTxtFld.text)! + str
        }
    }
    
   

}
