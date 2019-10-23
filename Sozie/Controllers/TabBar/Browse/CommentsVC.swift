//
//  CommentsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
public enum CommentType: String {
    case post
    case product
}
class CommentsVC: UIViewController {

    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var addCommentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var allReviewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var currentProduct: Product?
    var currentPost: Post?
    var commentsViewModel: [CommentsViewModel] = []
    var reviews: [Review] = [] {
        didSet {
            commentsViewModel.removeAll()
            for review in reviews {
                let viewModel = CommentsViewModel(title: nil, attributedTitle: self.getAttributedStringWith(name: review.addedBy.username, text: review.text), description: review.createdAt, imageURL: URL(string: review.addedBy.picture))
                commentsViewModel.append(viewModel)
            }
            setReviewButton(totalCount: reviews.count)
            tableView.reloadData()
        }
    }
    func getAttributedStringWith(name: String, text: String) -> NSAttributedString {
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "SegoeUI-Bold", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor(hex: "282828") ]
        let myString = NSMutableAttributedString(string: name + " ", attributes: myAttribute)
        let myAttributeText = [ NSAttributedString.Key.font: UIFont(name: "SegoeUI", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor(hex: "A6A6A6") ]
        let myStringText = NSMutableAttributedString(string: text, attributes: myAttributeText)
        myString.append(myStringText)
        return myString
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Comments"
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                let titleImageURL = URL(string: brand.titleImage)
                self.titleImageView.sd_setImage(with: titleImageURL, completed: nil)
            }
        }
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            detailTextLabel.text = productName + "\n" +  productDescription
        }
        var priceString = ""
        var searchPrice = 0.0
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + String(format: "%0.2f", searchPrice)
        }
        priceLabel.text = priceString
        if currentPost?.canPostReview == true {
            addCommentHeightConstraint.constant = 24.0
        } else {
            addCommentHeightConstraint.constant = 0.0
        }
        if let totalCount = currentPost?.reviews?.totalCount {
            setReviewButton(totalCount: totalCount)
        }
        addCommentTextField.delegate = self
        fetchCommentsFromServer()
    }

    func setReviewButton(totalCount: Int) {
        if totalCount <= 2 {
            allReviewButton.setTitle(String(totalCount ) + " Reviews", for: .normal)
        } else {
            allReviewButton.setTitle("View all " + String(totalCount) + " reviews", for: .normal)
        }
    }
    func fetchCommentsFromServer() {
        var reviewType: CommentType = CommentType.post
        var parentId: String = ""
        if let post = currentPost {
            reviewType = CommentType.post
            parentId = String(post.postId)
        } else {
            reviewType = CommentType.product
            if let prodId = currentProduct?.productStringId {
                parentId = prodId
            }
        }
        SVProgressHUD.show()
        ServerManager.sharedInstance.reviewList(postId: parentId, type: reviewType) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.reviews = response as! [Review]
            } else {
                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
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

}
extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsViewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = commentsViewModel[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        if tableViewCell == nil {
            tableView.register(UINib(nibName: viewModel.reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentReview = reviews[indexPath.row]
            if currentReview.addedBy.userId == UserDefaultManager.getCurrentUserId() {
                ServerManager.sharedInstance.deleteReview(reviewId: currentReview.reviewId) { (isSuccess, response) in
                    if isSuccess {
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.commentsViewModel.remove(at: indexPath.row)
                        self.reviews.remove(at: indexPath.row)
                        tableView.endUpdates()
                    } else {
                        UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let currentReview = reviews[indexPath.row]
        return currentReview.addedBy.userId == UserDefaultManager.getCurrentUserId()
    }
}
extension CommentsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            UtilityManager.showMessageWith(title: "Warning!", body: "Please enter text.", in: self)
        } else {
            SVProgressHUD.show()
            var dataDict = [String: Any]()
            dataDict["added_by"] = UserDefaultManager.getCurrentUserId()
            dataDict["post"] = currentPost?.postId
            dataDict["text"] = textField.text
            ServerManager.sharedInstance.addReview(params: dataDict) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.fetchCommentsFromServer()
                    textField.text = ""
                } else {
                    UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
                }
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
