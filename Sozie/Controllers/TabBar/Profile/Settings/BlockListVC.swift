//
//  BlockListVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD

class BlockListVC: UIViewController {
    let reuseIdentifier = "BlockedUserCell"
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModels: [BlockedUserCellViewModel] = []
    var users: [User] = [] {
        didSet {
            viewModels.removeAll()
            for user in users {
                let viewModel = BlockedUserCellViewModel(title: user.username, attributedTitle: nil, imageURL: URL(string: user.picture ?? ""))
                viewModels.append(viewModel)
            }
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchListFromServer()
    }
    
    func fetchListFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.blockedList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.users = response as! [User]
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
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BlockListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        }
        guard let cell = tableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? BlockedUserCell {
            currentCell.delegate = self
        }
        
        return cell
    }
}
extension BlockListVC: BlockedUserCellDelegate {
    func unblockButtonTapped(button: UIButton) {
        let currentUser = users[button.tag]
        SVProgressHUD.show()
        ServerManager.sharedInstance.unBlockUser(userId: currentUser.userId) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.tableView.beginUpdates()
                self.users.remove(at: button.tag)
                self.tableView.deleteRows(at: [IndexPath(item: button.tag, section: 0)], with: .fade)
                self.tableView.endUpdates()
            } else {
                let error = response as! Error
                UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
            }
        }
    }
}
