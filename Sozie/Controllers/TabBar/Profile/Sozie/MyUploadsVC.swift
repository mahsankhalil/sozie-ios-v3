//
//  MyUploadsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class MyUploadsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var serverParams = [String: Any]()
    var nextURL: String?
    var viewModels: [UserPostCellViewModel] = []
    var currentPost: UserPost?
    var posts: [UserPost] = [] {
        didSet {
            for post in posts {
                var sizeString = ""
//                if post.sizeType == "GN" {
//                    sizeString = "Size Worn: " + post.sizeValue
//                } else {
//                    sizeString = "Size Worn: " + post.sizeType + " " + post.sizeValue
//                }
                sizeString = "Size Worn: " + post.sizeValue
                let viewModel = UserPostCellViewModel(subtitle: sizeString, imageURL: URL(string: post.thumbURL))
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverParams.removeAll()
        posts.removeAll()
        viewModels.removeAll()
        getPostsFromServer()
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
                self.countLabel.text = String(paginatedData.count) + ( paginatedData.count <= 1 ? " Upload" : " Uploads")
            }
        }
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
