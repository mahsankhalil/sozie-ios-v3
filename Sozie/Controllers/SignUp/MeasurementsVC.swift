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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


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
            doubletextFieldCell.configureCellData(cellType: .height)
            return doubletextFieldCell
        }
        else if indexPath.row == 1
        {
            singleTextFieldCell.sizes = sizes
            singleTextFieldCell.selectedWaist = selectedWaist
            singleTextFieldCell.configureCellData(cellType: .waist)
            return singleTextFieldCell
        }
        else if indexPath.row == 2
        {
            singleTextFieldCell.sizes = sizes
            singleTextFieldCell.selectedHip = selectedHip
            singleTextFieldCell.configureCellData(cellType: .hips)
            
            return singleTextFieldCell
        }
        else
        {
            doubletextFieldCell.sizes = sizes
            doubletextFieldCell.configureCellData(cellType: .braSize)
            return doubletextFieldCell

        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 3
        {
            return 59.0
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
        popUpInstnc.closeHandler = { [weak self] in
            popUpVC.dismiss()
        }
    }
    
    
}

extension MeasurementsVC : SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: Int, type: MeasurementType) {
        if type == .hips
        {
            selectedHip = value
        }
        else if type == .waist
        {
            selectedWaist = value
        }
        tblVu.reloadData()
    }
}
