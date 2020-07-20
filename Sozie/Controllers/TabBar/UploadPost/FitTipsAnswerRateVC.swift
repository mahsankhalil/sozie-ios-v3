//
//  FitTipsAnswerRateVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/11/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import Cosmos
class FitTipsAnswerRateVC: UIViewController {
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
    var viewModels: [RatingQuestionsViewModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rateView.settings.updateOnTouch = true
        rateView.settings.filledColor = UIColor(hex: "ffbe25")
        rateView.settings.emptyColor = UIColor(hex: "e0e0e0")
        rateView.settings.emptyBorderColor = UIColor.clear
        rateView.settings.filledBorderColor = UIColor.clear
        rateView.rating = 0.0
        rateView.settings.fillMode = .full
        (self.parent?.parent as? PopupController)?.updatePopUpSize()
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
            if fitTips?[tipsIndex].question.count == 1 {
                rateView.isHidden = false
                tableView.isHidden = true
            } else {
                rateView.isHidden = true
                tableView.isHidden = false
                self.makeViewModelForQuestions()
            }
            if let answer = fitTips?[tipsIndex].question[quesIndex].answer {
                if let rating = Double(answer) {
                    rateView.rating = rating
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        (self.parent?.parent as? PopupController)?.updatePopUpSize()
    }
    func getControllerheight() -> CGFloat {
        if let tipsIndex = fitTipsIndex {
            if fitTips?[tipsIndex].question.count == 1 {
                return 225.0
            }
        }
        return 330.0
    }
    func makeViewModelForQuestions() {
        if let tipsIndex = fitTipsIndex, let allFitTips = fitTips {
            for question in allFitTips[tipsIndex].question {
                var rating: Double?
                if let answer = question.answer {
                    rating = Double(answer)
                }
                let viewModel = RatingQuestionsViewModel(title: question.questionText, attributedTitle: nil, rating: rating)
                viewModels.append(viewModel)
            }
            self.tableView.reloadData()
        }
    }
    func checkIfRatingGiven() -> Bool {
        if let tipsIndex = fitTipsIndex, let allFitTips = fitTips, let questIndex = questionIndex {
            if allFitTips[tipsIndex].question.count == 1 {
                let answer = String(Int(self.rateView.rating))
                allFitTips[tipsIndex].question[questIndex].answer = answer
                allFitTips[tipsIndex].question[questIndex].isAnswered = true
                return true
            }
            for question in allFitTips[tipsIndex].question {
                if question.answer == nil {
                    return false
                }
            }
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        if checkIfRatingGiven() == true {
            if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
//                if questIndex == fitTips[fitTipIndex].question.count - 1 {
                    if fitTipIndex == fitTips.count - 1 {
                        (self.navigationController as! FitTipsNavigationController).closeHandler!()
                        return
                    } else {
                        fitTipIndex = fitTipIndex + 1
                        questIndex = 0
                    }
//                } else {
//                    questIndex = questIndex + 1
//                }
                let fitTip = fitTips[fitTipIndex]
                if fitTip.question[0].type == "R" || fitTip.question[0].type == "C" {
                    navigateToTableAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex, type: fitTip.question[0].type)
                } else if fitTip.question[0].type == "T" {
                    //Text Input
                    navigateToTextAnswer(fitTipIndex: fitTipIndex, questIndex: fitTipIndex)
                } else if fitTip.question[0].type == "S" {
                    navigateToRateAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
                } else if fitTip.question[0].type == "L" {
                    navigateToRadioAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
               }
            }
        } else {
            UtilityManager.showErrorMessage(body: "Please select rating.", in: self)
        }
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
    func navigateToRateAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerRateVC") as! FitTipsAnswerRateVC
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToRadioAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerRadioVC") as! FitTipsAnswerRadioVC
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
extension FitTipsAnswerRateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell")
        if tableViewCell == nil {
            tableView.register(UINib(nibName: "RatingTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingTableViewCell")
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell")
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let ratingCell = cell as? RatingTableViewCell {
            ratingCell.delegate = self
        }
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        return cell
    }
}
extension FitTipsAnswerRateVC: RatingTableViewCellDelegate {
    func ratingGiven(rating: Double, index: Int) {
        if let tipsIndex = fitTipsIndex, let allFitTips = fitTips {
            allFitTips[tipsIndex].question[index].answer = String(Int(rating))
            allFitTips[tipsIndex].question[index].isAnswered = true
        }
    }
}
