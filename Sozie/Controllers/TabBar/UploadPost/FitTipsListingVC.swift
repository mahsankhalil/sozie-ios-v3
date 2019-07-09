//
//  FitTipsListingVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsListingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    var fitTips: [FitTips] = [] {
        didSet {
            viewModels.removeAll()
            for fitTip in fitTips {
                let viewModel = FitTipsViewModel(title: fitTip.label, attributedTitle: nil, isSelected: false)
                viewModels.append(viewModel)
            }
        }
    }
    var viewModels: [FitTipsViewModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FitTipsListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DisclosureCell")
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: "DisclosureCell", bundle: nil), forCellReuseIdentifier: "DisclosureCell")
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: "DisclosureCell")
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fitTip = fitTips[indexPath.row]
        if fitTip.question[0].type == "R" || fitTip.question[0].type == "C" {
            //Single selection
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerPickerVC") as! FitTipsAnswerPickerVC
//            destVC.fitTipsIndex = indexPath.row
//            destVC.questionIndex = 0
//            destVC.fitTips = fitTips
//            self.navigationController?.pushViewController(destVC, animated: true)
//        } else if fitTip.question[0].type == "C" {
            //Multiple selection
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTableVC") as! FitTipsAnswerTableVC
            destVC.fitTipsIndex = indexPath.row
            destVC.questionIndex = 0
            destVC.fitTips = fitTips
            destVC.type = fitTip.question[0].type
            self.navigationController?.pushViewController(destVC, animated: true)
        } else if fitTip.question[0].type == "T" {
            //Text Input
            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTextVC") as! FitTipsAnswerTextVC
            destVC.fitTipsIndex = indexPath.row
            destVC.questionIndex = 0
            destVC.fitTips = fitTips
            self.navigationController?.parent?.viewDidAppear(true)
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
}
