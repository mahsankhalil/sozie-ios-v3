//
//  SelectCountryVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class SelectCountryVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    var countriesList : [Country]?
    var selectedCountryId : Int?
    
    var currentUserType : UserType?

    var signUpDict : [String : Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromServer()
    }
    

    // MARK: - Custom Methods
    
    func fetchDataFromServer()
    {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getCountriesList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess
            {
                self.countriesList = response as? [Country]
                self.tblVu.reloadData()
            }
            
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSignUpEmailVC"
        {
            let vc = segue.destination as! SignUpEmailVC
            vc.signUpDict = signUpDict
        }
        else if segue.identifier == "toWorkVC"
        {
            let vc = segue.destination as! SelectWorkVC
            vc.signUpDict = signUpDict
        }
    }
 
    
    
    // MARK: - Actions
    
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if selectedCountryId != nil
        {
            signUpDict[User.CodingKeys.country.stringValue] = selectedCountryId
            signUpDict[User.CodingKeys.type.stringValue] = currentUserType?.rawValue
            if currentUserType == .shopper
            {
                performSegue(withIdentifier: "toSignUpEmailVC", sender: self)
            }
            else if currentUserType == .sozie
            {
                performSegue(withIdentifier: "toWorkVC", sender: self)
            }
        }
        else
        {
            UtilityManager.showErrorMessage(body: "Please select Country.", in: self)
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}

extension SelectCountryVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CountryCell! = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell
        
        
        
        if cell == nil {
            tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell
        }
        let currentCountry = countriesList![indexPath.row]
        cell.titleLbl.text = currentCountry.code
        if selectedCountryId == currentCountry.countryId
        {
            cell.checkMarkImgVu.isHidden = false
        }
        else
        {
            cell.checkMarkImgVu.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCountry = countriesList![indexPath.row]
        selectedCountryId = currentCountry.countryId
        tblVu.reloadData()
    }
    
}
