//
//  FitTipsAnswerTextVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/4/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class FitTipsAnswerTextVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    var currentProduct: Product?
    var fitTipsIndex: Int?
    var questionIndex: Int?
    var fitTips: [FitTips]?
    var timer: Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.textColor = UtilityManager.getGenderColor()
        var review = ""
        if let tipsIndex = fitTipsIndex, let quesIndex = questionIndex {
            titleLabel.text = fitTips?[tipsIndex].question[quesIndex].questionText
            if let answer = fitTips?[tipsIndex].question[quesIndex].answer {
                review = answer
                textView.text = review
            }
        }
        textView.delegate = self
        textView.becomeFirstResponder()
//        (self.parent?.parent as? PopupController)?.updatePopUpSize()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        //Showing border around textview
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        refreshReviewContents(review: review)
        
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
    @objc func dismissKeyboard() {
        self.textView.resignFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        (self.parent?.parent as? PopupController)?.updatePopUpSize()
    }
    @IBAction func backButtonTaped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        if textView.text.count < 200 {
            //UtilityManager.showErrorMessage(body: "Please enter comment", in: self)
            self.view.makeToast("Please complete your review!")
        } else {
            if var fitTipIndex = fitTipsIndex, var questIndex = questionIndex, let fitTips = fitTips {
                let answer = self.textView.text//.deletingPrefix("I wish ")
                fitTips[fitTipIndex].question[questIndex].answer = answer
                fitTips[fitTipIndex].question[questIndex].isAnswered = true
                if questIndex == fitTips[fitTipIndex].question.count - 1 {
                    if fitTipIndex == fitTips.count - 1 {
                        if isFitTipsCompleted() {
                            (self.navigationController as! FitTipsNavigationController).closeHandler!()
                            gotoFitTipsReviewVC()
                            return
                        } else {
                            self.view.makeToast("FitTips not completed yet!")
                            return
                        }
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
        }
    }
    private func gotoFitTipsReviewVC() {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsShowReviewVC") as! FitTipsShowReviewVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTips = fitTips
        present(destVC, animated: true)
    }
    func isFitTipsCompleted() -> Bool {
        if let fitTips = fitTips {
            for fitTip in fitTips {
                for quest in fitTip.question where quest.isAnswered == false {
                        return false
                }
            }
        }
        return true
    }
    func navigateToTextAnswer(fitTipIndex: Int, questIndex: Int) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FitTipsAnswerTextVC") as! FitTipsAnswerTextVC
        destVC.currentProduct = self.currentProduct
        destVC.fitTipsIndex = fitTipIndex
        destVC.questionIndex = questIndex
        destVC.fitTips = fitTips
//        self.navigationController?.parent?.viewDidAppear(true)
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
    
    private func refreshReviewContents(review: String) {
        let textCount = review.count
        questionLabel.text = getQuestionTitle(length: textCount)
        characterCountLabel.text = getRemainingQuestionLength(length: textCount)
        progressBar.progress = getCurrentProgress(length: textCount)
    }

    private func getQuestionTitle(length: Int) -> String? {
        if length >= 0 && length <= 40 {
            questionLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return "Go Ahead!"
        }

        if (length >= 41 && length <= 80) {
            questionLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return "Where would you wear this?"
        }

        if (length >= 81 && length <= 120) {
            questionLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return "What did you like or how'd it feel?"
        }

        if (length >= 121 && length <= 160) {
            questionLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return "What could have been better?"
        }

        if (length >= 161 && length <= 200) {
            questionLabel.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
            return "How have you styled it and how else would you wear it?"
        }
        
        if (length > 200) {
            questionLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.7450980392, blue: 0.9882352941, alpha: 1)
            return "Great Review!"
        }

        return ""
    }
    
    private func getRemainingQuestionLength(length: Int) -> String {
        if (length >= 0 && length <= 40) {
            let remaining = 40 - length
            if (remaining == 0) {
                return "Minimum 40 Characters"
            } else if (remaining == 1) {
                return "Minimum \(remaining) Character"
            } else {
                return "Minimum \(remaining) Characters"
            }
        }

        if (length >= 41 && length <= 80) {
            let remaining = 80 - length
            if (remaining == 0) {
                return "Minimum 40 Characters"
            } else if (remaining == 1) {
                return "Minimum \(remaining) Character"
            } else {
                return "Minimum \(remaining) Characters"
            }
        }

        if (length >= 81 && length <= 120) {
            let remaining = 120 - length
            if (remaining == 0) {
                return "Minimum 40 Characters"
            } else if (remaining == 1) {
                return "Minimum \(remaining) Character"
            } else {
                return "Minimum \(remaining) Characters"
            }
        }

        if (length >= 121 && length <= 160) {
            let remaining = 160 - length
            if remaining == 0 {
               return "Minimum 40 Characters"
            } else if remaining == 1 {
                return "Minimum \(remaining) Character"
            } else {
                return "Minimum \(remaining) Characters"
            }
        }

        if (length >= 161 && length <= 200) {
            let remaining = 200 - length
            if remaining > 1 {
               return "Minimum \(remaining) Characters"
            }
            else {
                return "Minimum \(remaining) Character"
            }
        }

        return "0 Remaining Character"
    }
    
    private func getCurrentProgress(length: Int) -> Float {
        var result: Float = 1.0//(Float(length) / Float(200))
        if (length < 200) {
            result = Float(length) / Float(200)
        }
        return result
    }
    
    private func countSpecialCharacter(userInput: String) -> Int {
        if userInput.count <= 0 {
            return 0
        }
        var countSpecial = 0
        let characters = Array(userInput)
        for (index, _) in characters.enumerated() {
            let value: String = String(characters[index])
            if value.range(of: "[^A-Za-z0-9' ',.?!]", options: .regularExpression) != nil {
                countSpecial += 1
            }
        }

        return countSpecial
    }

}
extension FitTipsAnswerTextVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.text)
        if countSpecialCharacter(userInput: textView.text) > 2 {
            UtilityManager.showErrorMessage(body: "Please submit a valid review.\nYou can not use more than 2 special characters.", in: self)
            var typed: String = textView.text
            typed.removeLast()
            textView.text = typed
        } else {
            refreshReviewContents(review: textView.text)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Type your comment..." {
//            textView.text = "I wish "
//        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "I wish " {
//            textView.text = "I wish "
//        } else {
//
//        }
    }

    @objc func getHints(timer: Timer) {
        if (textView.text.count < 200) {
            questionLabel.text = "KEEP GOING"
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(getHints), userInfo: nil, repeats: false)
        return true
//        let  char = text.cString(using: String.Encoding.utf8)!
//        let isBackSpace = strcmp(char, "\\b")
//        if isBackSpace == -92 {
//            // If backspace is pressed this will call
//            if textView.text == "I wish " {
//                return false
//            }
//        }
//        return true
    }
}
