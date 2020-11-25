//
//  FitTipsAnswerRadioVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/25/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsAnswerRadioVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var answerView: UIView!
    var arrayOfButtons = [UIButton]()
    var currentProduct: Product?
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
    var currentSelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = UtilityManager.getGenderColor()
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
        }
        (self.parent?.parent as? PopupController)?.updatePopUpSize()
        
        if let fitTipIndex = fitTipsIndex, let questIndex = questionIndex, let fitTips = fitTips {
            if questIndex == fitTips[fitTipIndex].question.count - 1 {
                if fitTipIndex == fitTips.count - 1 {
                    nextButton.setTitle("Done", for: .normal)
                } else {
                    nextButton.setTitle("Next", for: .normal)
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
            if let options = fitTips?[tipsIndex].question[quesIndex].options {
                var index = 0
                self.drawButtonInView(currentView: self.answerView, titles: options)
                for option in options {
                    if let answer = fitTips?[tipsIndex].question[quesIndex].answer {
                        if checkIfAnswered(text: option.optionText, answer: answer) {
                            // question is being answered
                            unseleAllButtons()
                            makeButtonSelected(index: index)
                        }
                    }
                    index = index + 1
                }
            }
        }
    }
    func checkIfAnswered(text: String, answer: String) -> Bool {
        let answers = answer.components(separatedBy: ",")
        for currentAnswer in answers where currentAnswer == text {
                return true
        }
        return false
    }
    func drawButtonInView(currentView: UIView, titles: [Options]) {
        let separation = (Double(UIScreen.main.bounds.size.width) / Double(titles.count + 2))
        let buttonsView = UIView(frame: CGRect(x: 0, y: 0, width: (20.0 * Double(titles.count)) + (separation * Double(titles.count)) - separation, height: 50.0))
        var index = 0.0
        for title in titles {
            let button = UIButton()
            button.setImage(UIImage(named: "Ellipse 49"), for: .normal)
            button.tag = Int(index)
            button.frame = CGRect(x: Double(index * 20) + Double(separation * index), y: 0, width: 20, height: 20)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            buttonsView.addSubview(button)
            if index < Double(titles.count - 1) {
                self.addLineAfterButton(button: button, buttonsView: buttonsView, separation: separation)
            }
            let label = UILabel(frame: CGRect(x: 0, y: Double(button.frame.height) + 10, width: separation, height: 20))
            label.numberOfLines = 0
            label.text = title.optionText
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.sizeToFit()
            label.textAlignment = .center
            label.center.x = button.center.x
            buttonsView.addSubview(label)
            index = index + 1
            arrayOfButtons.append(button)
        }
        buttonsView.center = currentView.center
        buttonsView.center.y = currentView.frame.size.height / 2.0
        currentView.addSubview(buttonsView)
    }
    func addLineAfterButton(button: UIButton, buttonsView: UIView, separation: Double) {
        let line = UIView(frame: CGRect(x: Double(button.frame.origin.x) + Double(button.frame.width) + 3.0, y: 0.0, width: separation - 6.0, height: 1.0))
        line.backgroundColor = UIColor.lightGray
        line.center.y = button.center.y
        buttonsView.addSubview(line)
    }
    func makeButtonSelected(index: Int) {
        arrayOfButtons[index].setImage(UIImage(named: "Selected"), for: .normal)
    }
    @objc func buttonTapped(sender: UIButton) {
        unseleAllButtons()
        currentSelectedIndex = sender.tag
        sender.setImage(UIImage(named: "Selected"), for: .normal)
    }
    func unseleAllButtons() {
        for button in arrayOfButtons {
            button.setImage(UIImage(named: "Ellipse 49"), for: .normal)
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
        if let currentAnswerIndex = currentSelectedIndex {
            if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
                let answer = fitTips[fitTipIndex].question[questIndex].options[currentAnswerIndex].optionText
                fitTips[fitTipIndex].question[questIndex].answer = answer
                fitTips[fitTipIndex].question[questIndex].isAnswered = true
                if questIndex == fitTips[fitTipIndex].question.count - 1 {
                    if fitTipIndex == fitTips.count - 1 {
                        (self.navigationController as! FitTipsNavigationController).closeHandler!()
                        gotoFitTipsReviewVC()
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
                } else if fitTip.question[0].type == "L" {
                    navigateToRadioAnswer(fitTipIndex: fitTipIndex, questIndex: questIndex)
                }
            }
        } else {
            UtilityManager.showErrorMessage(body: "Please select an option.", in: self)
        }
    }
    private func gotoFitTipsReviewVC() {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsShowReviewVC") as! FitTipsShowReviewVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTips = fitTips
        present(destVC, animated: true)
    }

    func navigateToTextAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTextVC") as! FitTipsAnswerTextVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.parent?.viewDidAppear(true)
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToPickerAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerPickerVC") as! FitTipsAnswerPickerVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToTableAnswer(fitTipIndex: Int, questIndex: Int, type: String) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTableVC") as! FitTipsAnswerTableVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        destVC.type = type
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToRateAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerRateVC") as! FitTipsAnswerRateVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func navigateToRadioAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerRadioVC") as! FitTipsAnswerRadioVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
