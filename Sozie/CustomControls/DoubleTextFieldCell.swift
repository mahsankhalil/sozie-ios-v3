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
    var sizeChart : SizeChart?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstTxtFld.setupAppDesign()
        secondTxtFld.setupAppDesign()
        


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellData(cellType:MeasurementType) {
        switch cellType {
        case .height:
            firstTxtFld.updateTxtFldWith(rightTitle: "ft", placeholder: "Height", measurementType: Constant.double, values1: sizeChart?.height.feet.convertArrayToString(), values2: sizeChart?.height.inches.convertArrayToString(), title: "HEIGHT", firsColumStr: "'", secondColumnStr: "\"")

            
            secondTxtFld.updateTxtFldWith(rightTitle: "in", placeholder: "", measurementType: Constant.double, values1: sizeChart?.height.feet.convertArrayToString(), values2: sizeChart?.height.inches.convertArrayToString(), title: "HEIGHT", firsColumStr: "'", secondColumnStr: "\"")
            


        case .braSize:
            
            firstTxtFld.updateTxtFldWith(rightTitle: "band", placeholder: "Bra Size", measurementType: Constant.double, values1: sizeChart?.bra.band.convertArrayToString(), values2: sizeChart?.bra.cup, title: "BRA SIZE", firsColumStr: "", secondColumnStr: "")
            

            secondTxtFld.updateTxtFldWith(rightTitle: "cup", placeholder: "", measurementType: Constant.double, values1: sizeChart?.bra.band.convertArrayToString(), values2: sizeChart?.bra.cup, title: "BRA SIZE", firsColumStr: "", secondColumnStr: "")
            

        default: break
        }
        if sizeChart == nil
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
    }
    
   

}
