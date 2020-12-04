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
    @IBOutlet weak var instructionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var doHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var donotHeightConstraint: NSLayoutConstraint!
    @IBOutlet var genderColorCollectionUI: [UIView]!
    @IBOutlet weak var instructionTableVIew: UITableView!
    @IBOutlet weak var doTableView: UITableView!
    @IBOutlet weak var donotTableView: UITableView!
    @IBOutlet weak var imgPosture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iGotITButton: DZGradientButton!
    weak var btnTappedDelegate: ButtonTappedDelegate?
    var instructionList = [String]()
    var doList = [String]()
    var donotList = [String]()
    var gender = "M"
    private func changeGenderUIColor() {
        for uiView in genderColorCollectionUI {
            uiView.backgroundColor = UtilityManager.getGenderColor()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        changeGenderUIColor()
        instructionTableVIew.register(NumberingTextFieldCell.nib(), forCellReuseIdentifier: NumberingTextFieldCell.identifier)
        doTableView.register(NumberingTextFieldCell.nib(), forCellReuseIdentifier: NumberingTextFieldCell.identifier)
        donotTableView.register(NumberingTextFieldCell.nib(), forCellReuseIdentifier: NumberingTextFieldCell.identifier)
        instructionTableVIew.delegate = self
        instructionTableVIew.dataSource = self
        doTableView.delegate = self
        doTableView.dataSource = self
        donotTableView.delegate = self
        donotTableView.dataSource = self
        gender = UserDefaultManager.getCurrentUserGender() ?? "M"
        if gender == "M" {
            imgPosture.image = UIImage(named: "instructionsMalePosture")
        } else {
            imgPosture.image = UIImage(named: "instructionsFemalePosture")
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickIGotIt(_ sender: DZGradientButton) {
        if let btnTappedDelegate = btnTappedDelegate {
            btnTappedDelegate.onButtonTappedDelegate(sender)
        } else {
            print("Delegate Definition not found")
        }
    }
    private func getUserInstructionList() -> [String] {
        return SozieInstructionUtility.getSozieUserInstructions(gender: gender)
    }
    private func getUserDoList() -> [String] {
        return SozieInstructionUtility.getSozieUserDoList(gender: gender)
    }
    private func getUserDonotList() -> [String] {
        return SozieInstructionUtility.getSozieUserDonotList(gender: gender)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        instructionList = getUserInstructionList()
        doList = getUserDoList()
        donotList = getUserDonotList()
        instructionTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        doTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        donotTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        instructionHeightConstraint.constant = CGFloat(44 * instructionList.count)
        doHeightConstraint.constant = CGFloat(doList.count * 44)
        donotHeightConstraint.constant = CGFloat(donotList.count * 44)
    }
}

extension SozieInstructionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.instructionTableVIew {
            return instructionList.count
        } else if tableView == self.doTableView {
            return doList.count
        } else if tableView == self.donotTableView {
            return donotList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberingTextFieldCell.identifier) as! NumberingTextFieldCell
        let listId = indexPath.row + 1
        let genderColor = UtilityManager.getGenderColor()
        if tableView == self.instructionTableVIew {
            let desc = instructionList[indexPath.row]
            cell.configure(itemNumber: listId, description: desc, itemNumberColor: genderColor)
            return cell
        } else if tableView == self.doTableView {
            let desc = doList[indexPath.row]
            cell.configure(itemNumber: listId, description: desc, itemNumberColor: genderColor)
            return cell
        } else if tableView == self.donotTableView {
            let desc = donotList[indexPath.row]
            cell.configure(itemNumber: listId, description: desc, itemNumberColor: genderColor)
            return cell
        }
        return UITableViewCell()
    }
}
