//
//  FitTipsAnswerPickerVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/3/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsAnswerPickerVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.textColor = UtilityManager.getGenderColor()
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
        }
    }

    @IBAction func backButtonTaped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
            fitTips[fitTipIndex].question[questIndex].answer = fitTips[fitTipIndex].question[questIndex].options[pickerView.selectedRow(inComponent: 0)].optionText
            fitTips[fitTipIndex].question[questIndex].isAnswered = true
            if questIndex == fitTips[fitTipIndex].question.count - 1 {
                if fitTipIndex == fitTips.count - 1 {
                    (self.navigationController as! FitTipsNavigationController).closeHandler!()
                    return
                } else {
                    fitTipIndex = fitTipIndex + 1
                    questIndex = 0
//                    self.navigationController?.popToRootViewController(animated: true)
//                    return
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
                navigateToTextAnswer(fitTipIndex: fitTipIndex, questIndex: fitTipIndex)
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

}
extension FitTipsAnswerPickerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            return fitTips?[tipsIndex].question[quesIndex].options.count ?? 0
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            return fitTips?[tipsIndex].question[quesIndex].options[row].optionText
        } else {
            return ""
        }
    }
}
