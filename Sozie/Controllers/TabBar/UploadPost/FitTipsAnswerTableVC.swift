//
//  FitTipsAnswerTableVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsAnswerTableVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
    var viewModels: [OptionsViewModel] = []
    var arrayOfSelectedIndexes: [Int] = []
    var type: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
            if let options = fitTips?[tipsIndex].question[quesIndex].options {
                viewModels.removeAll()
                var index = 0
                for option in options {
                    var viewModel = OptionsViewModel(title: option.optionText, attributedTitle: nil, isCheckmarkHidden: true)
                    if let answer = fitTips?[tipsIndex].question[quesIndex].answer {
                        if checkIfAnswered(text: option.optionText, answer: answer) {
                            viewModel.isCheckmarkHidden = false
                            arrayOfSelectedIndexes.append(index)
                        }
                    }
                    viewModels.append(viewModel)
                    index = index + 1
                }
            }
        }
    }
    func checkIfAnswered(text: String, answer: String) -> Bool {
        let answers = answer.components(separatedBy: ",")
        for currentAnswer in answers {
            if currentAnswer == text {
                return true
            }
        }
        return false
    }

    @IBAction func backButtonTaped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        if type == "R" && arrayOfSelectedIndexes.isEmpty {
            UtilityManager.showMessageWith(title: "Oops!", body: "You forgot to select an option!", in: self)
        } else if type == "C" && arrayOfSelectedIndexes.count < 2 {
            UtilityManager.showMessageWith(title: "Oops!", body: "You must select 2 options!", in: self)
        } else {
            if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
                var arrayOfAnswers = [String]()
                for index in arrayOfSelectedIndexes {
                    arrayOfAnswers.append(fitTips[fitTipIndex].question[questIndex].options[index].optionText)
                }
                fitTips[fitTipIndex].question[questIndex].answer = arrayOfAnswers.makeArrayJSON()
                fitTips[fitTipIndex].question[questIndex].isAnswered = true
                if questIndex == fitTips[fitTipIndex].question.count - 1 {
                    if fitTipIndex == fitTips.count - 1 {
                        (self.navigationController as! FitTipsNavigationController).closeHandler!()
                        return
                    } else {
                        fitTipIndex = fitTipIndex + 1
                        questIndex = 0
//                        self.navigationController?.popToRootViewController(animated: true)
//                        return
                    }
                } else {
                    questIndex = questIndex + 1
                }
                let fitTip = fitTips[fitTipIndex]
                if fitTip.question[0].type == "R" || fitTip.question[0].type == "C" {
                    //Single selection
//                    navigateToPickerAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
//                } else if fitTip.question[0].type == "C" {
                    //Multiple selection
                    navigateToTableAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex, type: fitTip.question[0].type)
                } else if fitTip.question[0].type == "T" {
                    //Text Input
                    navigateToTextAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
                }
            }
        }
//        if let tipsIndex = fitTipsIndex {
//            if let fitTip = fitTips?[tipsIndex] {
//                if fitTip.question[0].type == "R" {
//                    //Single selection
//
//                } else if fitTip.question[0].type == "C" {
//                    //Multiple selection
//
//                } else if fitTip.question[0].type == "T" {
//                    //Text Input
//
//                }
//            }
//        }
    }
    func navigateToTextAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTextVC") as! FitTipsAnswerTextVC
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.parent?.viewDidAppear(true)
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToPickerAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerPickerVC") as! FitTipsAnswerPickerVC
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToTableAnswer(fitTipIndex: Int, questIndex: Int, type: String) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTableVC") as! FitTipsAnswerTableVC
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        destVC.type = type
        self.navigationController?.pushViewController(destVC, animated: true)
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

extension FitTipsAnswerTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "TitleAndCheckmarkCell")
        if tableViewCell == nil {
            tableView.register(UINib(nibName: "TitleAndCheckmarkCell", bundle: nil), forCellReuseIdentifier: "TitleAndCheckmarkCell")
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleAndCheckmarkCell")
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentType = type {
            if currentType == "C" {
                if arrayOfSelectedIndexes.contains(indexPath.row) {
                    arrayOfSelectedIndexes.removeAll { $0 == indexPath.row }
                    viewModels[indexPath.row].isCheckmarkHidden = true
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    if arrayOfSelectedIndexes.count < 2 {
                        arrayOfSelectedIndexes.append(indexPath.row)
                        viewModels[indexPath.row].isCheckmarkHidden = false
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    } else {
                        viewModels[arrayOfSelectedIndexes[0]].isCheckmarkHidden = true
                        arrayOfSelectedIndexes.remove(at: 0)
                        arrayOfSelectedIndexes.append(indexPath.row)
                        viewModels[indexPath.row].isCheckmarkHidden = false
                        tableView.reloadData()
                    }
                }
            } else if currentType == "R" {
                if arrayOfSelectedIndexes.contains(indexPath.row) {
                    arrayOfSelectedIndexes.removeAll { $0 == indexPath.row }
                    viewModels[indexPath.row].isCheckmarkHidden = true
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    if arrayOfSelectedIndexes.count < 1 {
                        arrayOfSelectedIndexes.append(indexPath.row)
                        viewModels[indexPath.row].isCheckmarkHidden = false
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    } else {
                        viewModels[arrayOfSelectedIndexes[0]].isCheckmarkHidden = true
                        arrayOfSelectedIndexes.remove(at: 0)
                        arrayOfSelectedIndexes.append(indexPath.row)
                        viewModels[indexPath.row].isCheckmarkHidden = false
                        tableView.reloadData()
                    }
                }
            }
        }
        
    }
}
