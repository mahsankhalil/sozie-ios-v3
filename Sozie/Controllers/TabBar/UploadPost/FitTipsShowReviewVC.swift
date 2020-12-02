//
//  FitTipsShowReviewVC.swift
//  Sozie
//
//  Created by Malik Hantash Nadeem on 24/11/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import Cosmos

class FitTipsShowReviewVC: UIViewController {
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var editButton: DZGradientButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewHeight: NSLayoutConstraint!
    var currentProduct: Product?
    var fitTips: [FitTips]?
    var questionList = [Question]()
    override func viewDidLoad() {
        super.viewDidLoad()
        populateProductData()
        populateCurrentUserData()
        populateOverralRating()
        populateReview()
        populateOtherReview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FitTipsSelectionCell.nib(), forCellReuseIdentifier: FitTipsSelectionCell.identifier)
        tableView.register(FitTipsRatingCell.nib(), forCellReuseIdentifier: FitTipsRatingCell.identifier)
    }
    override func viewWillLayoutSubviews() {
        self.tableViewHeight?.constant = self.tableView.contentSize.height
//        self.scrollViewHeight?.constant = self.scrollView.contentSize.height
        //scrollView.contentSize = CGSize(width: 375, height: 700)
        self.reviewHeight?.constant = self.reviewTextView.contentSize.height
    }
    @IBAction func onButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func populateProductData() {
        var priceString = ""
        var searchPrice = 0.0
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + String(format: "%0.2f", searchPrice)
        }
        productPriceLabel.text = priceString
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            productDescriptionLabel.text = productName + "\n" +  productDescription
        }
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                brandImageView.sd_setImage(with: URL(string: brand.titleImage), completed: nil)
            }
        }
        assignImageURL()
    }
    func assignImageURL() {
        if var imageURL = currentProduct?.merchantImageURL {
            if imageURL == "" || imageURL.count < 4 {
                if let imageURLTarget = currentProduct?.imageURL {
                    productImageView.sd_setImage(with: URL(string: imageURLTarget), completed: nil)
                }
            } else {
                if imageURL.contains("|") {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
                productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
            }
        } else if let imageURL = currentProduct?.imageURL {
            productImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
    }
    func populateCurrentUserData() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2.0
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        profileImageView.clipsToBounds = true
        if let currentUser = UserDefaultManager.getCurrentUserObject() {
            if let firstName = currentUser.firstName, let lastName = currentUser.lastName {
                self.nameLabel.text = firstName + " " + lastName
            }
            if let imageURL = currentUser.picture {
                if imageURL != "" {
                    profileImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
            }
        }
    }
    func populateOverralRating() {
        rateView.settings.updateOnTouch = false
        rateView.settings.filledColor = UIColor(hex: "ffbe25")
        rateView.settings.emptyColor = UIColor(hex: "e0e0e0")
        rateView.settings.emptyBorderColor = UIColor.clear
        rateView.settings.filledBorderColor = UIColor.clear
        rateView.rating = 0.0
        rateView.settings.fillMode = .full
        if let fitTipsList = fitTips {
            for fitTip in fitTipsList {
                for question in fitTip.question {
                    if question.type == "S" && fitTip.question.count == 1 {
                        if question.isAnswered {
                            if let rating = Double(question.answer ?? "0") {
                                rateView.rating = rating
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    func populateReview() {
        if let fitTipsList = fitTips {
            for fitTip in fitTipsList {
                for question in fitTip.question {
                    if question.type == "T" {
                        reviewTextView.text = question.answer
                        break
                    }
                }
            }
        }
    }
    func populateOtherReview() {
        //First getting the selection type data
        if let fitTipsList = fitTips {
            for fitTip in fitTipsList {
                for question in fitTip.question {
                    let type = question.type
                    if type == "R" || type == "C" || type == "L" {
                        questionList.append(question)
                    }
                }
            }
        }
        //Then get the other rating questions
        if let fitTipsList = fitTips {
            for fitTip in fitTipsList {
                for question in fitTip.question {
                    let type = question.type
                    if type == "S" && fitTip.question.count == 3 {
                        questionList.append(question)
                    }
                }
            }
        }
        print("Total: \(questionList.count)")
        for question in questionList {
            print("Name: \(question.questionText) Answer: \(question.answer) Options Count: \(question.options.count)")
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
    func checkIfAnswered(text: String, answer: String) -> Bool {
        let answers = answer.components(separatedBy: ",")
        for currentAnswer in answers where currentAnswer == text {
                return true
        }
        return false
    }
}

extension FitTipsShowReviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension FitTipsShowReviewVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionList[section].type == "S" {
            return 1
        }
        return questionList[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questionList[indexPath.section].type == "S" {
            let cell = tableView.dequeueReusableCell(withIdentifier: FitTipsRatingCell.identifier, for: indexPath) as! FitTipsRatingCell
            let question = questionList[indexPath.section]
            if question.isAnswered {
                if let rating = Double(question.answer ?? "0") {
                    cell.configure(rating: rating)
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: FitTipsSelectionCell.identifier, for: indexPath) as! FitTipsSelectionCell
        let question = questionList[indexPath.section]
        let optionName = question.options[indexPath.row].optionText
        if question.type == "C" {
            if let answer = question.answer {
                if (checkIfAnswered(text: optionName, answer: answer)) {
                    cell.configure(imageName: "fitTips_selected", optionName: optionName)
                } else {
                    cell.configure(imageName: "fitTips_not_selected", optionName: optionName)
                }
            }
        } else {
            if question.answer == optionName {
                cell.configure(imageName: "fitTips_selected", optionName: optionName)
            } else {
                cell.configure(imageName: "fitTips_not_selected", optionName: optionName)
            }
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return questionList[section].questionText
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 35))
        label.text = questionList[section].questionText
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "SegoeUI-SemiBold", size: 15.0)
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
