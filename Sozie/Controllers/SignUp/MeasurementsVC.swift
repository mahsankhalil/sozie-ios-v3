//
//  MeasurementsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
import SVProgressHUD
import PopupController

public enum MeasurementType: Int {
    case height
    case waist
    case hips
    case braSize
}

class LocalMeasurement: NSObject {
    var bra: String?
    var height: String?
    var bodyShape: String?
    var hip: String?
    var cup: String?
    var waist: String?
}

class MeasurementsVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var uploadBtn: DZGradientButton!
    
    var sizes: Size?
    var currentMeasurement = LocalMeasurement()
    
    var rowViewModels: [RowViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentMeasurement = LocalMeasurement()
        fetchDataFromServer()
    }
    
    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getSizeCharts(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                guard let size = response as? Size else { return }

                let heightViewModel = DoubleTextFieldCellViewModel(title: "HEIGHT", columnUnit: ["ft", "in"], columnPlaceholder: ["Height", ""], columnValueSuffix: ["'", "\""], columnValues: [size.height.feet.convertArrayToString(), size.height.inches.convertArrayToString()], textFieldDelegate: self, displayError: false, errorMessage: "Please Select Height", measurementType: .height)
                
                let waistViewModel = SingleTextFieldCellViewModel(title: "WAIST", text: nil, placeholder: "Waist", values: size.waist.convertArrayToString(), valueSuffix: "\"", buttonTappedDelegate: self, textFieldDelegate: self, displayError: false, errorMessage: "Please Select Waist", measurementType: .waist)
                
                let hipsViewModel = SingleTextFieldCellViewModel(title: "HIPS", text: nil, placeholder: "Hips", values: size.hip.convertArrayToString(), valueSuffix: "\"", buttonTappedDelegate: self, textFieldDelegate: self, displayError: false, errorMessage: "Please Select Hips", measurementType: .hips)
                
                let braViewModel = DoubleTextFieldCellViewModel(title: "BRA SIZE", columnUnit: ["brand", "cup"], columnPlaceholder: ["Bra Size", ""], columnValueSuffix: ["", ""], columnValues: [size.bra.band.convertArrayToString(), size.bra.cup], textFieldDelegate: self, displayError: false, errorMessage: "Please Select Bra Size", measurementType: .braSize)
                
                self.rowViewModels = [heightViewModel, waistViewModel, hipsViewModel, braViewModel]
                self.sizes = size
                self.tblVu.reloadData()
            } else {
                let err = response as? Error
                UtilityManager.showErrorMessage(body: err?.localizedDescription ?? "Something went wrong" , in: self)
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
    
    private func isValidMeasurements() -> Bool {
        return currentMeasurement.height != nil && currentMeasurement.waist != nil &&
            currentMeasurement.hip != nil && currentMeasurement.bra != nil && currentMeasurement.cup != nil
    }
    
    @IBAction func uploadBtnTapped(_ sender: Any) {
        if isValidMeasurements() {
            var dataDict = [String : Any]()
            dataDict["height"] = currentMeasurement.height!
            dataDict["waist"] = currentMeasurement.waist!
            dataDict["hip"] = currentMeasurement.hip!
            dataDict["bra"] = currentMeasurement.bra!
            dataDict["cup"] = currentMeasurement.cup!
            let paramDict = ["measurement" : dataDict]
            SVProgressHUD.show()
            ServerManager.sharedInstance.updateProfile(params: paramDict, imageData: nil) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.performSegue(withIdentifier: "toUploadProfilePic", sender: self)
                } else {
                    let error = response as! Error
                    UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                }
            }
        } else {
            func setError(for index: Int, isError: Bool) {
                let rowViewModel = rowViewModels[index]
                if var errorViewModel = rowViewModel as? ErrorViewModeling {
                    errorViewModel.displayError = isError
                    rowViewModels[index] = errorViewModel as! RowViewModel
                }
            }
            
            setError(for: 0, isError: currentMeasurement.height == nil)
            setError(for: 1, isError: currentMeasurement.waist == nil)
            setError(for: 2, isError: currentMeasurement.hip == nil)
            setError(for: 3, isError: currentMeasurement.bra == nil || currentMeasurement.cup == nil)

            tblVu.reloadData()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MeasurementsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = rowViewModels[indexPath.row]
        
        var reuseIdentifier: String? = nil
        if let reuseIdentifierProvider = rowViewModel as? ReuseIdentifierProviding {
            reuseIdentifier = reuseIdentifierProvider.reuseIdentifier
        }
        
        guard let identifier = reuseIdentifier else { return UITableViewCell() }
        
        var tableViewcell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if tableViewcell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            tableViewcell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        
        guard let cell = tableViewcell else { return UITableViewCell() }
        cell.tag = indexPath.row
        
        if let cell = cell as? CellConfigurable {
            cell.setup(rowViewModel)
        }
        
        if let cell = cell as? UIButtonProviding {
            cell.button.tag = indexPath.row
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowViewModel = rowViewModels[indexPath.row]
        if let _ = rowViewModel as? DoubleTextFieldCellViewModel {
            return 71.0
        }
        return 83.0
    }
}

extension MeasurementsVC: TextFieldDelegate {
    
    func updateCurrentMeasurement(_ index: Int, text: String, text2: String? = nil) {
        if let measurementTypeProvider = rowViewModels[index] as? MeasurementTypeProviding {
            let type = measurementTypeProvider.measurementType
            switch type {
            case .hips:
                currentMeasurement.hip = text
            case .waist:
                currentMeasurement.waist = text
            case .braSize:
                currentMeasurement.bra = text
                currentMeasurement.cup = text2
            case .height:
                let heightInches = (Double(text2 ?? "1.0") ?? 1.0)/12.0
                let inchesStr = String(format: "%0.4f", heightInches)
                currentMeasurement.height = text + inchesStr
            }
        }
    }
    
    func textFieldDidUpdate(_ sender: Any?, text: String) {
        guard let cell = sender as? UITableViewCell else { return }
        updateCurrentMeasurement(cell.tag, text: text)
    }
    
    func textFieldDidUpdate(_ sender: Any?, textField1: String, textField2: String) {
        guard let cell = sender as? UITableViewCell else { return }
        updateCurrentMeasurement(cell.tag, text: textField1, text2: textField2)
    }
}

extension MeasurementsVC: ButtonTappedDelegate {
    func onButtonTappedDelegate(_ sender: Any?) {
        guard let button = sender as? UIButton, let sizes = sizes else { return }
        let index = button.tag
        let rowViewModel = rowViewModels[index]
        if let measurementModel = rowViewModel as? MeasurementTypeProviding {
            let type = measurementModel.measurementType
            let popUpInstnc = SizeChartPopUpVC.instance(arrayOfSizeChart: sizes.sizeChart, arrayOfGeneral: sizes.general, type: type)
            let popUpVC = PopupController
                .create(self)
                .show(popUpInstnc)
            popUpInstnc.delegate = self
            popUpInstnc.closeHandler = { []  in
                popUpVC.dismiss()
            }
        }
    }
}

extension MeasurementsVC: SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: Int, type: MeasurementType) {
        let index = rowViewModels.index {
            if let measurementModel = $0 as? MeasurementTypeProviding {
                return measurementModel.measurementType == type
            }
            return false
        }
        
        if let index = index {
            updateCurrentMeasurement(index, text: String(describing: value))
            
            if var singleTextFieldCellViewModel = rowViewModels[index] as? SingleTextFieldCellViewModel {
                singleTextFieldCellViewModel.text = String(describing: value)
                rowViewModels[index] = singleTextFieldCellViewModel
            }

            let indexPath = IndexPath(row: index, section: 0)
            tblVu.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
