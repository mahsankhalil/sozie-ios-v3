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
    @IBOutlet weak var instructionTableVIew: UITableView!
    var closeButton: UIButton?
    var crossButton: UIButton?
    weak var btnTappedDelegate: ButtonTappedDelegate?
    var instructionSet = [[String]]()
    var instructionSetTitle = [String]()
    var instructionList = [String]()
    var doList = [String]()
    var donotList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionTableVIew.register(NumberingTextFieldCell.nib(), forCellReuseIdentifier: NumberingTextFieldCell.identifier)
        instructionTableVIew.register(SozieInstructionsHeaderTableViewCell.nib(),
                                      forHeaderFooterViewReuseIdentifier: SozieInstructionsHeaderTableViewCell.identifier)
        instructionTableVIew.delegate = self
        instructionTableVIew.dataSource = self
        
    }
    @objc func onClickIGotIt(_ sender: DZGradientButton) {
        if let btnTappedDelegate = btnTappedDelegate {
            btnTappedDelegate.onButtonTappedDelegate(closeButton)
        } else {
            print("Delegate Definition not found")
        }
    }
    @objc func onClickCrossBtn(_ sender: UIButton) {
        if let btnTappedDelegate = btnTappedDelegate {
            btnTappedDelegate.onButtonTappedDelegate(crossButton)
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
        instructionTableVIew.rowHeight = UITableView.automaticDimension
        instructionTableVIew.estimatedRowHeight = 44
    }
    private func getTitleHeaderCellView(width: CGFloat, height: CGFloat, sideMargin: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: width,
                                              height: height))
        // Add Cross Button View
        let crossButton = UIButton(frame: CGRect(x: headerView.frame.width - 30, y: 15,
                                                 width: 30, height: 30))
        crossButton.setImage(UIImage(named: "Cross-1"), for: .normal)
        self.crossButton = crossButton
        crossButton.addTarget(self, action: #selector(onClickCrossBtn(_:)), for: .touchUpInside)
        headerView.addSubview(crossButton)
        //Add Attributed Text View
        let myAttr1 = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Condensed Bold", size: 16.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
                    ]
        let str = "SCROLL TO THE BOTTOM OF THE SCREEN AND CLICK ON   I GET IT   TO SEE YOUR REQUESTS"
        let titleStr = NSMutableAttributedString(
                                string: str, attributes: myAttr1)
        let range = (str as NSString).range(of: " I GET IT ", options: .caseInsensitive)
        titleStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
        titleStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UtilityManager.getGenderColor(), range: range)
        let label = UILabel(frame: CGRect(x: sideMargin, y: 30,
                                          width: headerView.frame.width - (sideMargin * 2),
                                          height: 70))
        label.attributedText = titleStr
        label.numberOfLines = 0
        label.textAlignment = .center
        headerView.addSubview(label)
        return headerView
    }
    private func getPictureCellView(width: CGFloat, height: CGFloat, sideMargin: CGFloat, imgStr: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: width,
                                              height: height))
        let imageName = imgStr
        let poseImage = UIImage(named: imageName)
        let poseImageView = UIImageView(frame: CGRect(x: sideMargin, y: 10,
                                                      width: width - (sideMargin * 2),
                                                      height: height - 10))
        poseImageView.image = poseImage
        headerView.addSubview(poseImageView)
        return headerView
    }
    private func getButtonCellView(width: CGFloat, height: CGFloat, sideMargin: CGFloat) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: width,
                                              height: height))
        let button = DZGradientButton(frame: CGRect(x: sideMargin, y: 10,
                                                    width: width - (sideMargin * 2),
                                                    height: height - 5))
        button.setTitle("I GOT IT", for: .normal)
        self.closeButton = button
        button.addTarget(self, action: #selector(onClickIGotIt), for: .touchUpInside)
        headerView.addSubview(button)
        return headerView
    }
}

extension SozieInstructionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.instructionTableVIew {
            if section == 0 || section == 2 || section == 5 {
                return 0
            }
            return instructionSet[section].count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberingTextFieldCell.identifier) as! NumberingTextFieldCell
        cell.translatesAutoresizingMaskIntoConstraints = false
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
        if section == 0 {
            return getTitleHeaderCellView(width: tableView.frame.width,
                                          height: 70,
                                          sideMargin: 21)
        }
        if section == 2 {
            if instructionSet[section].count != 0 {
                return getPictureCellView(width: tableView.frame.width,
                                          height: 200,
                                          sideMargin: 21,
                                          imgStr: instructionSet[section][0])
            }
            return UIView(frame: CGRect(x: 0, y: 0,
                                        width: tableView.frame.width,
                                        height: 1))
        }
        if section == 5 {
            return getButtonCellView(width: tableView.frame.width,
                                     height: 60,
                                     sideMargin: 42)
        }
        let header = tableView.dequeueReusableHeaderFooterView(
                        withIdentifier: SozieInstructionsHeaderTableViewCell.identifier) as! SozieInstructionsHeaderTableViewCell
        header.configure(instructionStr: instructionSetTitle[section],
                         lineColor: UtilityManager.getGenderColor())
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        if section == 2 {
            if  instructionSet[section].count != 0 {
                return 200
            }
            return 0
        }
        if section == 5 {
            return 75
        }
        return 45
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return instructionSet.count
    }
}
