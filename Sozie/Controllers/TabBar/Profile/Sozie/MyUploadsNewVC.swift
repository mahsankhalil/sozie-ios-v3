//
//  MyUploadsNewVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 9/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SideMenu

class MyUploadsNewVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    var reuseableIdentifier = "MyUploadsCell"
    var serverParams = [String: Any]()
    var nextURL: String?
    var viewModels: [UserPostWithUploadsViewModel] = []
    var currentPost: UserPost?
    var posts: [UserPost] = [] {
        didSet {
            viewModels.removeAll()
            for post in posts {
                let viewModel = UserPostWithUploadsViewModel(uploads: post.uploads, isTutorial: post.isTutorialPost, isApproved: post.isApproved, isModerated: post.isModerated)
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverParams.removeAll()
        posts.removeAll()
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
            self.tableView.bottomRefreshControl?.endRefreshing()
            if isSuccess {
                let paginatedData = response as! PostPaginatedResponse
                self.posts.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                self.countLabel.text = String(paginatedData.count) + ( paginatedData.count <= 1 ? " Upload" : " Uploads")
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
extension MyUploadsNewVC: UITableViewDelegate, UITableViewDataSource {
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
extension MyUploadsNewVC: MyUploadsCellDelegate {
    func deleteButtonTapped(button: UIButton) {
    }
    func viewBalanceButtonTapped(button: UIButton) {
        let storyBoard = UIStoryboard(name: "TabBar", bundle: Bundle.main)
        let balanceVC = storyBoard.instantiateViewController(withIdentifier: "MyBalanceVC") as! MyBalanceVC
        self.present(balanceVC, animated: true, completion: nil)
//        SideMenuManager.default.menuRightNavigationController?.pushViewController(balanceVC, animated: true)
//        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
//            self.navigationController?.pushViewController(balanceVC, animated: true)
//        }
    }
    func resetTutorialButtonTapped(button: UIButton) {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            profileParentVC.tabViewController?.displayControllerWithIndex(0, direction: .reverse, animated: true)
        }
    }
}
