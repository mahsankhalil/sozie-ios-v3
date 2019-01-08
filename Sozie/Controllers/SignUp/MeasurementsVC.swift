//
//  MeasurementsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/8/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import MaterialTextField
class MeasurementsVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var heightInchtxtFld: MFTextField!
    @IBOutlet weak var heightFeetTxtFld: MFTextField!
    @IBOutlet weak var waistTxtFld: MFTextField!
    @IBOutlet weak var hipsTxtFld: MFTextField!
    @IBOutlet weak var braSizeBandTxtFld: MFTextField!
    @IBOutlet weak var braSizeCupTxtFld: MFTextField!
    @IBOutlet weak var waistNotSureBtn: UIButton!
    @IBOutlet weak var uploadBtn: DZGradientButton!
    @IBOutlet weak var hipsNotSureBtn: UIButton!
    @IBOutlet weak var shipBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupALLTxtFlds()
    }
    
    func setupALLTxtFlds()
    {
        heightFeetTxtFld.setupAppDesign()
        heightFeetTxtFld.applyRightVuLblWith(title: "ft")
        heightInchtxtFld.setupAppDesign()
        heightInchtxtFld.applyRightVuLblWith(title: "in")
        waistTxtFld.setupAppDesign()
        hipsTxtFld.setupAppDesign()
        braSizeBandTxtFld.setupAppDesign()
        braSizeBandTxtFld.applyRightVuLblWith(title: "band")
        braSizeCupTxtFld.setupAppDesign()
        braSizeCupTxtFld.applyRightVuLblWith(title: "cup")
        
        fetchDataFromServer()

    }
    
    func fetchDataFromServer()
    {
        ServerManager.sharedInstance.getSizeCharts(params: [:]) { (isSuccess, response) in
            
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
    }
    
}
