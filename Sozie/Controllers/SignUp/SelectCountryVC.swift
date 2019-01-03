//
//  SelectCountryVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SelectCountryVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: DZGradientButton!
    @IBOutlet weak var tblVu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Actions
    
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}

extension SelectCountryVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:CountryCell! = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell
        
        
        
        if cell == nil {
            tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell
        }
        
        
        return cell
    }
    
    
}
