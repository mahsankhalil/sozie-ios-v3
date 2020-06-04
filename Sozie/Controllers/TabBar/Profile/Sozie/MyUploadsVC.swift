//
//  MyUploadsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

public enum PostFilterType: Int {
    case success
    case inReview
    case redo
}
class MyUploadsVC: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var inReviewButton: UIButton!
    @IBOutlet weak var reDoButton: UIButton!
    @IBOutlet weak var successCountLabel: UILabel!
    @IBOutlet weak var inReviewCountLabel: UILabel!
    @IBOutlet weak var redoCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currentFilterType: PostFilterType?
    var reuseableIdentifier = "MyUploadsCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var serverParams = [String: Any]()
    var nextURL: String?
    var viewModels: [UserPostWithUploadsViewModel] = []
    var currentPost: UserPost?
    var posts: [UserPost] = [] {
        didSet {
            viewModels.removeAll()
            for post in posts {
                let viewModel = UserPostWithUploadsViewModel(uploads: post.uploads, isTutorial: post.isTutorialPost, isApproved: post.isApproved, isModerated: post.isModerated, productURL: post.productImageURL ?? "", postType: currentFilterType ?? .success)
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentFilterType = .success
        self.tableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        reloadData()
    }
    func reloadData() {
        switch currentFilterType {
        case .success:
            setupButtonSelected(button: successButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: reDoButton)
            hideOtherLabels(label: successCountLabel)
        case .inReview:
            setupButtonSelected(button: inReviewButton)
            setUpButtonUnselected(button: successButton)
            setUpButtonUnselected(button: reDoButton)
            hideOtherLabels(label: inReviewCountLabel)
        case .redo:
            setupButtonSelected(button: reDoButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: successButton)
            hideOtherLabels(label: redoCountLabel)
        default:
            setupButtonSelected(button: successButton)
            setUpButtonUnselected(button: inReviewButton)
            setUpButtonUnselected(button: reDoButton)
            hideOtherLabels(label: successCountLabel)
        }
    }
    func setUpButtonUnselected(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hex: "0ABAB5").cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(hex: "898989"), for: .normal)
    }
    func setupButtonSelected(button: UIButton) {
        button.backgroundColor = UIColor(hex: "0ABAB5")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverParams.removeAll()
        posts.removeAll()
        serverParams["review_action"] = "A"
        getPostsFromServer()
        reloadData()
    }
    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            getPostsFromServer()
        } else {
            serverParams.removeValue(forKey: "next")
        }
    }
    func getPostsFromServer() {
        serverParams["user_id"] = UserDefaultManager.getCurrentUserId()
        ServerManager.sharedInstance.getUserPosts(params: serverParams) { (isSuccess, response) in
            if isSuccess {
                let paginatedData = response as! PostPaginatedResponse
                self.posts.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                self.applyCountLabel(count: paginatedData.count)
//                self.countLabel.text = String(paginatedData.count) + ( paginatedData.count <= 1 ? " Upload" : " Uploads")
            }
        }
    }
    func applyCountLabel(count: Int) {
        switch currentFilterType {
        case .success:
            self.successCountLabel.text = String(count)
        case .inReview:
            self.inReviewCountLabel.text = String(count)
        case .redo:
            self.redoCountLabel.text = String(count)
        default:
            return
        }
    }
    func resetData() {
        serverParams.removeAll()
        posts.removeAll()
        redoCountLabel.text = ""
        inReviewCountLabel.text = ""
        successCountLabel.text = ""
    }
    func hideOtherLabels(label: UILabel) {
        label.isHidden = false
        if label == successCountLabel {
            inReviewCountLabel.isHidden = true
            redoCountLabel.isHidden = true
        } else if label == inReviewCountLabel {
            successCountLabel.isHidden = true
            redoCountLabel.isHidden = true
        } else if label == redoCountLabel {
            successCountLabel.isHidden = true
            inReviewCountLabel.isHidden = true
        }
    }

    @IBAction func successButtonTapped(_ sender: Any) {
        currentFilterType = .success
        reloadData()
        resetData()
        serverParams["review_action"] = "A"
        getPostsFromServer()
    }
    @IBAction func inReviewButtonTapped(_ sender: Any) {
        currentFilterType = .inReview
        reloadData()
        resetData()
        serverParams["review_action"] = "P"
        getPostsFromServer()
    }
    @IBAction func redoButtonTapped(_ sender: Any) {
        currentFilterType = .redo
        reloadData()
        resetData()
        serverParams["review_action"] = "R"
        getPostsFromServer()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toProductDetail" {
//            let destVC = segue.destination as? ProductDetailVC
//            destVC?.currentProduct = currentPost?.product
//            destVC?.currentPostId = currentPost?.postId
        }
    }
}

extension MyUploadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        let identifier = reuseableIdentifier
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if tableViewCell == nil {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? MyUploadsCell {
            currentCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        if viewModel.isTutorial {
            return 220
        }
        return 250.0
    }
}
extension MyUploadsVC: MyUploadsCellDelegate {
    func editButtonTapped(button: UIButton) {
        
    }
    func warningButtonTapped(button: UIButton) {
        let popUpInstnc = RejectionReasonPopupWithoutTitle.instance()
//         popUpInstnc.delegate = self
         let popUpVC = PopupController
             .create(self.tabBarController?.navigationController ?? self)
             .show(popUpInstnc)
         _ = popUpVC.didCloseHandler { (_) in
         }
//         popUpInstnc.closeHandler = { []  in
//             popUpVC.dismiss()
//        }

    }
    func imageTapped(collectionViewTag: Int, cellTag: Int) {
        if currentFilterType == .redo {
            if cellTag != 0 {
                let popUpInstnc = RejectionReasonPopup.instance(reason: posts[collectionViewTag].uploads[cellTag - 1].rejectionReason ?? "", collectionViewTag: collectionViewTag, cellTag: cellTag)
                popUpInstnc.delegate = self
                let popUpVC = PopupController
                    .create(self.tabBarController?.navigationController ?? self)
                     .show(popUpInstnc)
                 _ = popUpVC.didCloseHandler { (_) in
                 }
            }
        }
    }
}
extension MyUploadsVC: RejectionResponseDelegate {
    func tryAgainButtonTapped(button: UIButton, collectionViewTag: Int?, cellTag: Int?) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            UtilityManager.openCustomCameraFrom(viewController: self, photoIndex: nil, progressTutorialVC: nil)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            UtilityManager.openGalleryFrom(viewController: self)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension MyUploadsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowViewModel = viewModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSizeCollectionViewCell", for: indexPath)
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth: Int = Int(UIScreen.main.bounds.size.width - 6 )
        let widthPerItem = Double(availableWidth/3)
        return CGSize(width: widthPerItem, height: widthPerItem )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPost = posts[indexPath.row]
        self.performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
