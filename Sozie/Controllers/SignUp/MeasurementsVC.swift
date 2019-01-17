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
public enum MeasurementType {
    case height
    case waist
    case hips
    case braSize
}

class MeasurementsVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
   
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var waistNotSureBtn: UIButton!
    @IBOutlet weak var uploadBtn: DZGradientButton!
    @IBOutlet weak var hipsNotSureBtn: UIButton!
    @IBOutlet weak var shipBtn: UIButton!


    
    var sizes : Size?

    var selectedHip : Int?
    var selectedWaist : Int?
    

    var currentMeasurement : LocalMeasurement?
    var shouldValidate = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currentMeasurement = LocalMeasurement()


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchDataFromServer()

    }
    
    func fetchDataFromServer()
    {

        SVProgressHUD.show()
        ServerManager.sharedInstance.getSizeCharts(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess
            {
                self.sizes = response as? Size
                self.tblVu.reloadData()
            }
            else
            {
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
    @IBAction func uploadBtnTapped(_ sender: Any) {
        shouldValidate = true
        if let height = currentMeasurement?.height , let waist = currentMeasurement?.waist , let hip = currentMeasurement?.hip , let bra = currentMeasurement?.bra , let cup = currentMeasurement?.cup
        {
            var dataDict = [String : Any]()
            dataDict["height"] = height
            dataDict["waist"] = waist
            dataDict["hip"] = hip
            dataDict["bra"] = bra
            dataDict["cup"] = cup
            
            let paramDict = ["measurement" : dataDict]
            SVProgressHUD.show()
            ServerManager.sharedInstance.updateProfile(params: paramDict, imageData: nil) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess
                {
                    self.performSegue(withIdentifier: "toUploadProfilePic", sender: self)
                }
                else
                {
                    let error = response as! Error
                    UtilityManager.showMessageWith(title: "Please Try Again", body: error.localizedDescription, in: self)
                }
            }
        }
        else
        {
            tblVu.reloadData()
        }
        
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
    }
    @IBAction func backBtnTapped(_ sender: Any) {

        self.dismiss(animated: true) {
            
        }
    }
    
}



extension MeasurementsVC : UITableViewDelegate , UITableViewDataSource , SingleTextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var singleTextFieldCell:SingleTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: "SingleTextFieldCell") as? SingleTextFieldCell
        var doubletextFieldCell :DoubleTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell") as? DoubleTextFieldCell
        
        
        if singleTextFieldCell == nil {
            tableView.register(UINib(nibName: "SingleTextFieldCell", bundle: nil), forCellReuseIdentifier: "SingleTextFieldCell")
            singleTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "SingleTextFieldCell") as? SingleTextFieldCell
        }
        
        if doubletextFieldCell == nil {
            tableView.register(UINib(nibName: "DoubleTextFieldCell", bundle: nil), forCellReuseIdentifier: "DoubleTextFieldCell")
            doubletextFieldCell = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell") as? DoubleTextFieldCell
        }
        singleTextFieldCell.delegate = self
        singleTextFieldCell.notSureBtn.tag = indexPath.row
        
        if indexPath.row == 0
        {
            doubletextFieldCell.sizes = sizes
            doubletextFieldCell.measurementType = .height
            doubletextFieldCell.shouldValidate = shouldValidate
            doubletextFieldCell.currentMeasurement = currentMeasurement

            doubletextFieldCell.configureCellData(cellType: .height)
            doubletextFieldCell.validateCellData()
            return doubletextFieldCell
        }
        else if indexPath.row == 1
        {
            singleTextFieldCell.sizes = sizes
            singleTextFieldCell.measurementType = .waist
            singleTextFieldCell.shouldValidate = shouldValidate
            singleTextFieldCell.currentMeasurement = currentMeasurement
            singleTextFieldCell.selectedWaist = selectedWaist
            singleTextFieldCell.configureCellData(cellType: .waist)
            singleTextFieldCell.validateCellData()
            return singleTextFieldCell
        }
        else if indexPath.row == 2
        {
            singleTextFieldCell.sizes = sizes

            singleTextFieldCell.measurementType = .hips
            singleTextFieldCell.shouldValidate = shouldValidate
            singleTextFieldCell.currentMeasurement = currentMeasurement
            singleTextFieldCell.selectedHip = selectedHip
            singleTextFieldCell.configureCellData(cellType: .hips)
            singleTextFieldCell.validateCellData()

            return singleTextFieldCell
        }
        else
        {
            doubletextFieldCell.sizes = sizes

            doubletextFieldCell.measurementType = .braSize
            doubletextFieldCell.shouldValidate = shouldValidate
            doubletextFieldCell.currentMeasurement = currentMeasurement

            doubletextFieldCell.configureCellData(cellType: .braSize)
            doubletextFieldCell.validateCellData()
            return doubletextFieldCell

        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 || indexPath.row == 3
//        {
//            return 71.0
//        }
//        else
//        {
//            return 83.0
//        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 3
        {
            return 71.0
        }
        else
        {
            return 83.0
        }
    }
    
    func singleTextFieldNotSureBtnTapped(btn: UIButton) {
        
        var type : MeasurementType
        if btn.tag == 1
        {
            type = .waist
        }
        else
        {
            type = .hips
        }
        let popUpInstnc = SizeChartPopUpVC.instance(arrayOfSizeChart: sizes?.sizeChart ?? [], arrayOfGeneral: sizes?.general ?? [], type: type )
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc)
        popUpInstnc.delegate = self
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
    
    
    
}

extension MeasurementsVC : SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: Int, type: MeasurementType) {
        if type == .hips
        {
            selectedHip = value

            currentMeasurement?.hip = String(value)

        }
        else if type == .waist
        {
            selectedWaist = value

            currentMeasurement?.waist = String(value)

        }
        tblVu.reloadData()
    }
}
