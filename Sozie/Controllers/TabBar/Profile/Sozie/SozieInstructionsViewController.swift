//
//  SozieInstructionsViewController.swift
//  Sozie
//
//  Created by Ahsan Khalil on 03/12/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class SozieInstructionsViewController: UIViewController {
    static let reuseIdentifier = "SozieInstructionsViewController"
    @IBOutlet weak var closeBtnInstructionLabel: UILabel!
    @IBOutlet weak var instructionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionTableVIew: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iGotITButton: DZGradientButton!
    @IBOutlet weak var crossButton: UIButton!
    weak var btnTappedDelegate: ButtonTappedDelegate?
    var instructionSet = [[String]]()
    var instructionSetTitle = [String]()
    var instructionList = [String]()
    var doList = [String]()
    var donotList = [String]()
    var gender = "M"
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionTableVIew.register(NumberingTextFieldCell.nib(), forCellReuseIdentifier: NumberingTextFieldCell.identifier)
        instructionTableVIew.register(SozieInstructionsHeaderTableViewCell.nib(),
                                      forHeaderFooterViewReuseIdentifier: SozieInstructionsHeaderTableViewCell.identifier)
        instructionTableVIew.delegate = self
        instructionTableVIew.dataSource = self
        gender = UserDefaultManager.getCurrentUserGender() ?? "M"
    }
    @IBAction func onClickIGotIt(_ sender: DZGradientButton) {
        if let btnTappedDelegate = btnTappedDelegate {
            btnTappedDelegate.onButtonTappedDelegate(sender)
        } else {
            print("Delegate Definition not found")
        }
    }
    @IBAction func onClickCrossBtn(_ sender: UIButton) {
        if let btnTappedDelegate = btnTappedDelegate {
            btnTappedDelegate.onButtonTappedDelegate(sender)
        } else {
            print("Delegate Definition not found")
        }
    }
    private func getUserInstructionSet() -> [[String]] {
        return SozieInstructionUtility.getSozieCompleteInstructionsSet()
    }
    private func getUserInstructionSetTitle() -> [String] {
        return SozieInstructionUtility.getSozieInstructionsSetTitleList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        instructionSet = getUserInstructionSet()
        instructionSetTitle = getUserInstructionSetTitle()
        instructionTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        var heightSize = 0
        for list in instructionSet {
            heightSize += list.count * 44
        }
        if instructionSet[1].count != 0 {
            heightSize += 200
        } else {
            heightSize += 30
        }
        heightSize += 105
        instructionHeightConstraint.constant = CGFloat(heightSize)
    }
}

extension SozieInstructionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.instructionTableVIew {
            if section == 1 {
                return 0
            }
            return instructionSet[section].count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberingTextFieldCell.identifier) as! NumberingTextFieldCell
        let listId = indexPath.row + 1
        let genderColor = UtilityManager.getGenderColor()
        if tableView == self.instructionTableVIew {
            let desc = instructionSet[indexPath.section][indexPath.row]
            cell.configure(itemNumber: listId, description: desc, itemNumberColor: genderColor)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if instructionSet[1].count != 0 {
                let imageName = instructionSet[1][0]
                let poseImage = UIImage(named: imageName)
                let poseImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                              width: tableView.frame.width,
                                                              height: 250))
                poseImageView.image = poseImage
                return poseImageView
            }
            return UIView(frame: CGRect(x: 0, y: 0,
                                        width: tableView.frame.width,
                                        height: 1))
        }
        let header = tableView.dequeueReusableHeaderFooterView(
                        withIdentifier: SozieInstructionsHeaderTableViewCell.identifier) as! SozieInstructionsHeaderTableViewCell
        header.configure(instructionStr: instructionSetTitle[section],
                         lineColor: UtilityManager.getGenderColor())
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if  instructionSet[1].count != 0 {
                return 200
            }
            return 0
        }
        return 45
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        instructionSet.count
    }
}
