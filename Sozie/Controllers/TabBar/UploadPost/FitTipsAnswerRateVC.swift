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
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
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
            if let answer = fitTips?[tipsIndex].question[quesIndex].answer {
                if let rating = Double(answer) {
                    rateView.rating = rating
                }
            }
        }
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
        if rateView.rating != 0.0 {
            if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
                let answer = String(Int(self.rateView.rating))
                fitTips[fitTipIndex].question[questIndex].answer = answer
                fitTips[fitTipIndex].question[questIndex].isAnswered = true
                if questIndex == fitTips[fitTipIndex].question.count - 1 {
                    if fitTipIndex == fitTips.count - 1 {
                        (self.navigationController as! FitTipsNavigationController).closeHandler!()
                        return
                    } else {
                        fitTipIndex = fitTipIndex + 1
                        questIndex = 0
                    }
                } else {
                    questIndex = questIndex + 1
                }
                let fitTip = fitTips[fitTipIndex]
                if fitTip.question[0].type == "R" || fitTip.question[0].type == "C" {
                    navigateToTableAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex, type: fitTip.question[0].type)
                } else if fitTip.question[0].type == "T" {
                    //Text Input
                    navigateToTextAnswer(fitTipIndex: fitTipIndex, questIndex: fitTipIndex)
                } else if fitTip.question[0].type == "S" {
                    navigateToRateAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
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
}
