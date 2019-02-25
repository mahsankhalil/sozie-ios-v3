//
//  RequestsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class RequestsVC: UIViewController {
    var reuseableIdentifier = "RequestTableViewCell"
    @IBOutlet weak var searchCountLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
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
    @IBAction func filterButtonTapped(_ sender: Any) {
        let popUpInstnc: PopupNavController? = PopupNavController.instance(type: nil, brandList: nil, filterType: FilterType.request )
        //        popUpInstnc?.popupDelegate = self
        let popUpVC = PopupController
            .create(self.tabBarController!)
        let options = PopupCustomOption.layout(.bottom)
        popUpVC.cornerRadius = 0.0
        _ = popUpVC.customize([options])
        _ = popUpVC.show(popUpInstnc!)
        popUpInstnc!.navigationHandler = { []  in
            UIView.animate(withDuration: 0.6, animations: {
                popUpVC.updatePopUpSize()
            })
        }
        popUpInstnc?.closeHandler = { [] in
            popUpVC.dismiss()
        }
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
    }
    
}
extension RequestsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)

        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseableIdentifier, bundle: nil), forCellReuseIdentifier: reuseableIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)
        }
        
        guard let cell = tableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        return cell
    }
}
