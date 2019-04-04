//
//  SozieProfileVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/6/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class SozieProfileVC: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModels: [UserPostCellViewModel] = []
    var nextURL: String?
    var currentPost: UserPost?
    var user: User?
    var serverParams = [String: Any]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var posts: [UserPost] = [] {
        didSet {
            for post in posts {
                let sizeString = "Size Worn: " + post.sizeType + "-" + post.sizeValue
                let viewModel = UserPostCellViewModel(subtitle: sizeString, imageURL: URL(string: post.thumbURL))
                viewModels.append(viewModel)
            }
            self.collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "PostSizeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostSizeCollectionViewCell")
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        collectionView.bottomRefreshControl = refreshControl
        getPostsFromServer()
        populateUserData()
    }
    func populateUserData() {
        if let currentUser = user {
            self.nameLabel.text = currentUser.username
            if let measurement = currentUser.measurement {
                if let bra = measurement.bra, let cup = measurement.cup {
                    braLabel.text = "Bra Size: " + String(bra) + cup
                }
                if let height = measurement.height {
                    let heightMeasurment = NSMeasurement(doubleValue: Double(height), unit: UnitLength.inches)
                    let feetMeasurement = heightMeasurment.converting(to: UnitLength.feet)
                    heightLabel.text = "Height: " + feetMeasurement.value.feetToFeetInches() + "  |"
                }
                if let hip = measurement.hip {
                    hipLabel.text = "Hip: " + String(hip) + "  |"
                }
                if let waist = measurement.waist {
                    waistLabel.text = "Waist: " + String(waist) + "  |"
                }
            }
            if currentUser.isFollowed == true {
                makeButtonFollowing()
            } else {
                makeButtonFollow()
            }
        }
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
        serverParams["user_id"] = user?.userId
        ServerManager.sharedInstance.getUserPosts(params: serverParams) { (isSuccess, response) in
            if isSuccess {
                let paginatedData = response as! PostPaginatedResponse
                self.posts.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
            }
        }
    }
    func makeButtonFollow() {
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor(hex: "7EA7E5")
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.layer.cornerRadius = 3.0
    }
    func makeButtonFollowing() {
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = UIColor.white
        followButton.setTitleColor(UIColor(hex: "7EA7E5"), for: .normal)
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor(hex: "7EA7E5").cgColor
        followButton.layer.cornerRadius = 3.0
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toProductDetail" {
            let destVC = segue.destination as? ProductDetailVC
            destVC?.currentProduct = currentPost?.product
            destVC?.currentPostId = currentPost?.postId
        }
    }

    @IBAction func followButtonTapped(_ sender: Any) {
        if let currentUser = user {
            if currentUser.isFollowed == false {
                var dataDict = [String: Any]()
                let userId = currentUser.userId
                dataDict["user"] = userId
                SVProgressHUD.show()
                ServerManager.sharedInstance.followUser(params: dataDict) { (isSuccess, _) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        self.user?.isFollowed = true
                        self.makeButtonFollowing()
                    }
                }
            } else {
                var dataDict = [String: Any]()
                let userId = currentUser.userId
                dataDict["user"] = userId
                SVProgressHUD.show()
                ServerManager.sharedInstance.unFollowUser(params: dataDict) { (isSuccess, _) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        self.user?.isFollowed = false
                        self.makeButtonFollow()
                    }
                }
            }
        }
    }
}
extension SozieProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
