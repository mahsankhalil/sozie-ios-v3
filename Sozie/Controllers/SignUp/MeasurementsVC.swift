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
import EasyTipView
import TPKeyboardAvoiding
public enum MeasurementType: Int {
    case height
    case waist
    case hips
    case braSize
    case size
    case waistHips
    case chest
}

class LocalMeasurement: NSObject {
    var bra: String?
    var height: String?
    var bodyShape: String?
    var hip: String?
    var cup: String?
    var waist: String?
    var size: String?
    var chest: String?
}

class MeasurementsVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var skipButton: DZGradientButton!
    @IBOutlet weak var skiptoDoItLaterButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!

    var sizes: Size?
    var currentMeasurement = LocalMeasurement()
    var rowViewModels: [RowViewModel] = []
    var isFromSignUp = false

    @IBOutlet weak var saveButton: DZGradientButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblVu.backgroundColor = UIColor.white
        segmentControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        if isFromSignUp {
            backBtn.isHidden = true
            saveButton.isHidden = true
        } else {
            saveButton.isHidden = false
            uploadBtn.isHidden = true
            skipButton.isHidden = true
            skipButton.shadowAdded = false
            skiptoDoItLaterButton.isHidden = true
            orLabel.isHidden = true
//            skipButton.isHidden = true
//            uploadBtn.setTitle("Save", for: .normal)
            backBtn.isHidden = false
            segmentControl.isHidden = true
        }
        setupMeasurement()
        fetchDataFromServer()
        if UserDefaultManager.getIfUserGuideShownFor(userGuide: UserDefaultKey.measurementUserGuide) == false {
        }
//        skipButton.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromSignUp {
            saveButton.shadowLayer?.removeFromSuperview()
        } else {
            skipButton.shadowLayer?.removeFromSuperview()
        }
    }
    func setupMeasurement() {
        if let user = UserDefaultManager.getCurrentUserObject() {
            currentMeasurement = LocalMeasurement()
            if let bra = user.measurement?.bra {
                currentMeasurement.bra = String(bra)
            }
            if let height = user.measurement?.height {
                currentMeasurement.height = String(height)
            }
            if let hip = user.measurement?.hip {
                currentMeasurement.hip = String(hip)
            }
            if let cup = user.measurement?.cup {
                currentMeasurement.cup = cup
            }
            if let waist = user.measurement?.waist {
                currentMeasurement.waist = String(waist)
            }
            if let size = user.measurement?.size {
                currentMeasurement.size = size
            }
            if let chest = user.measurement?.chest {
                currentMeasurement.chest = String(chest)
            }
            if let unit = user.measurement?.unit {
                if unit == "IN" {
                    self.segmentControl.selectedSegmentIndex = 0
                } else {
                    self.segmentControl.selectedSegmentIndex = 1
                }
            }
        } else {
            currentMeasurement = LocalMeasurement()
        }
    }
    func showTipView() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            let text = "Filling these will help us match you to your Sozies!"
            var prefer = UtilityManager.tipViewGlobalPreferences()
            prefer.drawing.arrowPosition = .left
            prefer.positioning.maxWidth = 96
            let tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
            tipView.show(animated: true, forView: self.titleLabel, withinSuperview: self.view)
            UserDefaultManager.setUserGuideShown(userGuide: UserDefaultKey.measurementUserGuide)
        }
    }
    func setSizeAccordingly(size: Size) {
        var heightInches: String?
        var heightFeet: String?
        var waist: String?
        var hip: String?
        var bra: String?
        var cup: String?
        var chest: String?
        if let height = self.currentMeasurement.height {
            heightInches = Double(height)?.inchesToRemainingInches()
            heightFeet = Double(height)?.inchesToFeet()
        }
        chest = self.currentMeasurement.chest
        waist = self.currentMeasurement.waist
        hip = self.currentMeasurement.hip
        bra = self.currentMeasurement.bra
        cup = self.currentMeasurement.cup
        let currentSize = self.currentMeasurement.size
        let wornSizes = size.sizes
        var isInches = true
        var unit = "in"
        var unitAbr = "\""
        var waistValues = size.waist.inches.convertArrayToString()
        var hipValues = size.hip.inches.convertArrayToString()
        var braBandValues = size.bra?.band.inches.convertArrayToString()
        var chestValues = size.chest?.inches.convertArrayToString()
        var heightCM = ""
        if self.segmentControl.selectedSegmentIndex != 0 {
            isInches = false
            unit = "cm"
            unitAbr = ""
            waistValues = size.waist.centimeters.convertArrayToString()
            hipValues = size.hip.centimeters.convertArrayToString()
            braBandValues = size.bra?.band.centimeters.convertArrayToString()
            chestValues = size.chest?.centimeters.convertArrayToString()
            heightCM = self.currentMeasurement.height ?? ""
        }
        let heightViewModelCM = SingleTextFieldCellViewModel(title: "HEIGHT", text: heightCM, placeholder: "Height", values: size.height.centimeters.convertArrayToString(), valueSuffix: "", buttonTappedDelegate: self, textFieldDelegate: self, displayError: false, errorMessage: "Please Select Height", measurementType: .height, columnUnit: unit)
        let heightViewModel = DoubleTextFieldCellViewModel(text1: heightFeet, text2: heightInches, title1: "HEIGHT(feet)", title2: "HEIGHT(Inches)", columnUnit: ["ft", "in"], columnPlaceholder: ["Height", ""], columnValueSuffix: ["'", "\""], columnValues: [size.height.feet.convertArrayToString(), size.height.inches.convertArrayToString()], textFieldDelegate: self, displayError: false, errorMessage: "Please Select Height", measurementType: .height)
        let waistHipsModel = DoubleTextFieldCellViewModel(text1: waist, text2: hip, title1: "WAIST", title2: "HIPS", columnUnit: [unit, unit], columnPlaceholder: ["Waist", "Hips"], columnValueSuffix: [unitAbr, unitAbr], columnValues: [waistValues, hipValues], textFieldDelegate: self, displayError: false, errorMessage: "Please Select Waist and Hips", measurementType: .waistHips)
        let braViewModel = DoubleTextFieldCellViewModel(text1: bra, text2: cup, title1: "BRA SIZE(Band)", title2: "BRA SIZE(Cup)", columnUnit: ["band", "cup"], columnPlaceholder: ["Bra Size", ""], columnValueSuffix: ["", ""], columnValues: [braBandValues ?? [], size.bra?.cup ?? []], textFieldDelegate: self, displayError: false, errorMessage: "Please Select Bra Size", measurementType: .braSize)
        var sizeDescString = "What dress size do you normally wear?"
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                sizeDescString = "What size do you normally wear?"
            }
        }
        let sizeWornViewModel = TitleTextFieldCellViewModel(title: sizeDescString, text: currentSize, values: wornSizes, measurementType: .size, textFieldDelegate: self, errorMessage: "Please enter your current dress size", displayError: false)
        let chestViewModel = SingleTextFieldCellViewModel(title: "CHEST", text: chest, placeholder: "Chest", values: chestValues ?? [], valueSuffix: unitAbr, buttonTappedDelegate: self, textFieldDelegate: self, displayError: false, errorMessage: "Please Select Chest size", measurementType: .chest, columnUnit: unit)
        var heightFinalViewModel: RowViewModel
        if isInches == true {
            heightFinalViewModel = heightViewModel
        } else {
            heightFinalViewModel = heightViewModelCM
        }
        var chestFinalViewModel: RowViewModel
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "F" {
                chestFinalViewModel = braViewModel
            } else {
                chestFinalViewModel = chestViewModel
            }
        } else {
            chestFinalViewModel = braViewModel
        }
        self.rowViewModels = [heightFinalViewModel, waistHipsModel, chestFinalViewModel, sizeWornViewModel]

    }
    func fetchDataFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getSizeCharts(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                guard let size = response as? AllSizes else { return }
                if let gender = UserDefaultManager.getCurrentUserGender() {
                    if gender == "F" {
                        self.setSizeAccordingly(size: size.female!)
                        self.sizes = size.female
                    } else {
                        self.setSizeAccordingly(size: size.male!)
                        self.sizes = size.male
                    }
                } else {
                    self.setSizeAccordingly(size: size.female!)
                    self.sizes = size.female
                }
                self.tblVu.reloadData()
            } else {
                let err = response as? Error
                UtilityManager.showErrorMessage(body: err?.localizedDescription ?? "Something went wrong", in: self)
            }
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toUploadProfilePic" {
            let destVC = segue.destination as? UploadProfilePictureVC
            destVC?.isFromSignUp = true
        }
    }
    func converArrayOfGeneralToStringArray(generalSizes: [General]) -> [String] {
        var sizes = [String]()
        for size in generalSizes {
            sizes.append(size.label)
        }
        return sizes
    }

    private func isValidMeasurements() -> Bool {
        return currentMeasurement.height != nil && currentMeasurement.height != "" && currentMeasurement.waist != nil && currentMeasurement.waist != "" &&
            currentMeasurement.hip != nil && currentMeasurement.hip != "" && ((currentMeasurement.bra != nil && currentMeasurement.bra != "" && currentMeasurement.cup != nil && currentMeasurement.cup != "") || (currentMeasurement.chest != nil && currentMeasurement.chest != "")) && currentMeasurement.size != nil && currentMeasurement.size != ""
    }

    @IBAction func uploadBtnTapped(_ sender: Any) {
        if isValidMeasurements() {
            let gender = UserDefaultManager.getCurrentUserGender()
            var dataDict = [String: Any]()
            dataDict["height"] = Int(Double(currentMeasurement.height!)!)
            dataDict["waist"] = Int(currentMeasurement.waist!)
            dataDict["hip"] = Int(currentMeasurement.hip!)
            if gender == "F" {
                dataDict["bra"] = Int(currentMeasurement.bra!)
                dataDict["cup"] = currentMeasurement.cup!
            } else if gender == "M" {
                dataDict["chest"] = Int(currentMeasurement.chest!)
            }
            dataDict["size"] = currentMeasurement.size
            dataDict["unit"] = "IN"
            if isFromSignUp {
                if self.segmentControl.selectedSegmentIndex == 0 {
                    dataDict["unit"] = "IN"
                } else {
                    dataDict["unit"] = "CM"
                }
            } else {
                if let user = UserDefaultManager.getCurrentUserObject() {
                    if let unit = user.measurement?.unit {
                        if unit == "IN" {
                            dataDict["unit"] = "IN"
                        } else {
                            dataDict["unit"] = "CM"
                        }
                    }
                }
            }
            updateProfileOnServer(dataDict: dataDict)
        } else {
            let gender = UserDefaultManager.getCurrentUserGender()
            self.setSizeAccordingly(size: self.sizes!)
            setError(for: 0, isError: currentMeasurement.height == nil)
            setError(for: 1, isError: currentMeasurement.waist == nil || currentMeasurement.hip == nil || currentMeasurement.waist == "" || currentMeasurement.hip == "")
            if gender == "F" {
                setError(for: 2, isError: currentMeasurement.bra == nil || currentMeasurement.cup == nil || currentMeasurement.bra == "" || currentMeasurement.cup == "")
            } else if gender == "M" {
                setError(for: 2, isError: currentMeasurement.chest == nil || currentMeasurement.chest == "")
            }
            setError(for: 3, isError: currentMeasurement.size == nil || currentMeasurement.size == "")
            tblVu.reloadData()
        }
    }
    func setError(for index: Int, isError: Bool) {
        let rowViewModel = rowViewModels[index]
        if var errorViewModel = rowViewModel as? ErrorViewModeling {
            errorViewModel.displayError = isError
            rowViewModels[index] = errorViewModel as! RowViewModel
        }
    }
    func updateProfileOnServer(dataDict: [String: Any]) {
        SVProgressHUD.show()
        ServerManager.sharedInstance.updateProfile(params: dataDict, imageData: nil) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let user = response as! User
                UserDefaultManager.updateUserObject(user: user)
                SegmentManager.createEntity(user: user)
                if self.isFromSignUp == false {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.performSegue(withIdentifier: "toUploadProfilePic", sender: self)
                }
            } else {
                let error = response as! Error
                UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
            }
        }
    }

    @IBAction func segmentControlValueChanged(_ sender: Any) {
        currentMeasurement = LocalMeasurement()
        fetchDataFromServer()
    }
    @IBAction func clickHereButtonTapped(_ sender: Any) {
        let gender = UserDefaultManager.getCurrentUserGender()
        if gender == "F" {
            performSegue(withIdentifier: "toMeasurementTutorial", sender: self)
        } else {
            performSegue(withIdentifier: "toMaleMeasurementTutorial", sender: self)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        if UserDefaultManager.isUserLoggedIn() {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension MeasurementsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = rowViewModels[indexPath.row]
        var reuseIdentifier: String?
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
        if (rowViewModel as? DoubleTextFieldCellViewModel) != nil {
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
            case .waistHips:
                currentMeasurement.waist = text
                currentMeasurement.hip = text2
            case .hips:
                currentMeasurement.hip = text
            case .waist:
                currentMeasurement.waist = text
            case .braSize:
                currentMeasurement.bra = text
                currentMeasurement.cup = text2
            case .height:
                if self.segmentControl.selectedSegmentIndex == 0 {
                    let heightInches = (Int(text2 ?? "") ?? 0) + ((Int(text) ?? 0) * 12)
                    //                let heightInches = (Double(text2 ?? "1.0") ?? 1.0)/12.0
                    if text2 != nil && text2 != "" {
                        let inchesStr = String(heightInches)
                        currentMeasurement.height = inchesStr
                    }
                } else {
                    currentMeasurement.height = text
                }
            case .size:
                currentMeasurement.size = text
            case .chest:
                currentMeasurement.chest = text
            }
        }
    }

    func textFieldDidUpdate(_ sender: Any?, text: String?) {
        guard let cell = sender as? UITableViewCell else { return }
        updateCurrentMeasurement(cell.tag, text: text ?? "")
    }

    func textFieldDidUpdate(_ sender: Any?, textField1: String?, textField2: String?) {
        guard let cell = sender as? UITableViewCell else { return }
        updateCurrentMeasurement(cell.tag, text: textField1 ?? "", text2: textField2)
    }
}
extension MeasurementsVC: ButtonTappedDelegate {
    func onButtonTappedDelegate(_ sender: Any?) {
//        guard let button = sender as? UIButton, let sizes = sizes else { return }
//        let index = button.tag
//        let rowViewModel = rowViewModels[index]
//        if let measurementModel = rowViewModel as? MeasurementTypeProviding {
//            let type = measurementModel.measurementType
//            let popUpInstnc = SizeChartPopUpVC.instance(arrayOfSizeChart: sizes.sizeChart, arrayOfGeneral: sizes.general, type: type, productSizeChart: nil)
//            let popUpVC = PopupController
//                .create(self)
//                .show(popUpInstnc)
//            popUpInstnc.delegate = self
//            popUpInstnc.closeHandler = { []  in
//                popUpVC.dismiss()
//            }
//        }
    }
}
extension MeasurementsVC: SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: Int?, type: MeasurementType?, sizeType: SizeType?, sizeValue: String?) {
        let index = rowViewModels.index {
            if let measurementModel = $0 as? MeasurementTypeProviding {
                return measurementModel.measurementType == type
            }
            return false
        }
        if let index = index {
            if let integerValue = value {
                updateCurrentMeasurement(index, text: String(describing: integerValue))
                if var singleTextFieldCellViewModel = rowViewModels[index] as? SingleTextFieldCellViewModel {
                    singleTextFieldCellViewModel.text = String(describing: integerValue)
                    rowViewModels[index] = singleTextFieldCellViewModel
                }
            }
            let indexPath = IndexPath(row: index, section: 0)
            tblVu.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
