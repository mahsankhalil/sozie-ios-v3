//
//  SelectWorkVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/10/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class SelectWorkVC: UIViewController {

    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: DZGradientButton!
    @IBOutlet weak var separatorVu: UIView!
    var selectedBrandId : Int?
    var brandList : [Brand]?
    var searchList : [Brand] = []
    var isNotFound = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        separatorVu.applyStandardContainerViewShadow()
        searchTxtFld.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromServer()
    }
    
    
    func fetchDataFromServer()
    {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess
            {
                self.brandList = response as? [Brand]
                self.searchList = self.brandList ?? []
                self.tblVu.reloadData()
            }
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField)
    {
        
        searchList.removeAll()
        if textField.text == ""
        {
            searchList = brandList ?? []
            self.tblVu.reloadData()
            return
        }
        for brand in brandList ?? []
        {
            if ((brand.label.lowercased().range(of: textField.text!.lowercased())) != nil)
            {
                searchList.append(brand)
            }
        }
        if ((brandList?.count ?? 0) > 0) && (searchList.count == 0)
        {
            isNotFound = true
        }
        else
        {
            isNotFound = false
        }
        
        
        self.tblVu.reloadData()
        
        
    }
    
    // MARK Text Field Delegate

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextBtnTapped(_ sender: Any) {
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}

extension SelectWorkVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNotFound
        {
            return 1
        }
        else
        {
            return searchList.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:WorkCell! = tableView.dequeueReusableCell(withIdentifier: "WorkCell") as? WorkCell
        
        
        
        if cell == nil {
            tableView.register(UINib(nibName: "WorkCell", bundle: nil), forCellReuseIdentifier: "WorkCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell") as? WorkCell
        }
        
        var notFoundCell:SearchNotFoundCell! = tableView.dequeueReusableCell(withIdentifier: "SearchNotFoundCell") as? SearchNotFoundCell
        
        
        
        if notFoundCell == nil {
            tableView.register(UINib(nibName: "SearchNotFoundCell", bundle: nil), forCellReuseIdentifier: "SearchNotFoundCell")
            notFoundCell = tableView.dequeueReusableCell(withIdentifier: "SearchNotFoundCell") as? SearchNotFoundCell
        }
        
        if isNotFound
        {
            return notFoundCell
        }
        else
        {
            let brand = searchList[indexPath.row]
            cell.titleLbl.text = brand.label
            if selectedBrandId == brand.brandId
            {
                cell.checkMarkImgVu.isHidden = false
            }
            else
            {
                cell.checkMarkImgVu.isHidden = true
            }
            
            
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentBrand = searchList[indexPath.row]
        selectedBrandId = currentBrand.brandId
        tblVu.reloadData()
    }
    
    
}
