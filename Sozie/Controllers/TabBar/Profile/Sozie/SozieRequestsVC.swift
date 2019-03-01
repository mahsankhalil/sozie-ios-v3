//
//  SozieRequestsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
class SozieRequestsVC: UIViewController {
    var reuseableIdentifier = "SozieRequestTableViewCell"
    @IBOutlet weak var searchCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var nextURL: String?
    var viewModels: [SozieRequestCellViewModel] = []
    var selectedProduct: Product?
    var serverParams: [String: Any] = [String: Any]()
    var requests: [SozieRequest] = [] {
        didSet {
            viewModels.removeAll()
            for request in requests {
                var imageURL = ""
                if let productImageURL = request.requestedProduct.imageURL {
                    imageURL = productImageURL.getActualSizeImageURL() ?? ""
                }
                if let feedId = request.requestedProduct.feedId {
                    if feedId == 18857 {
                        if let merchantImageURL = request.requestedProduct.merchantImageURL {
                            let delimeter = "|"
                            let url = merchantImageURL.components(separatedBy: delimeter)
                            imageURL = url[0]
                        }
                    }
                }
                let subtitle = "Size Requested: (" + request.sizeValue + ")"
                let title = "Requested by " + request.user.username
                let description = request.user.username +  " Measurements:"
                let viewModel = SozieRequestCellViewModel(description: description, subtitle: subtitle, isSelected: request.isAccepted, title: title, attributedTitle: nil, bra: request.user.measurement?.bra, height: request.user.measurement?.height, hip: request.user.measurement?.hip, cup: request.user.measurement?.cup, waist: request.user.measurement?.waist, imageURL: URL(string: imageURL))
                viewModels.append(viewModel)
            }
            if viewModels.count == 0 {
                noDataLabel.isHidden = false
            } else {
                noDataLabel.isHidden = true
            }
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        fetchAllSozieRequests()
    }
    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            fetchAllSozieRequests()
        } else {
            serverParams.removeValue(forKey: "next")
        }
    }
    
    func fetchAllSozieRequests() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getSozieRequest(params: serverParams) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let paginatedData = response as! RequestsPaginatedResponse
                self.requests.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                self.searchCountLabel.text = String(paginatedData.count) + " REQUESTS"
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
            destVC?.currentProduct = selectedProduct
        }
    }
}
extension SozieRequestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)
        
        if tableViewCell == nil {
            tableView.register(UINib(nibName: reuseableIdentifier, bundle: nil), forCellReuseIdentifier: reuseableIdentifier)
            tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseableIdentifier)
        }
        
        guard let cell = tableViewCell else { return UITableViewCell() }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel)
        }
        if let cellIndexing = cell as? ButtonProviding {
            cellIndexing.assignTagWith(indexPath.row)
        }
        if let currentCell = cell as? SozieRequestTableViewCell {
            currentCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = requests[indexPath.row].requestedProduct
        performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
extension SozieRequestsVC: SozieRequestTableViewCellDelegate {
    func acceptRequestButtonTapped(button: UIButton) {
        let currentProduct = requests[button.tag].requestedProduct
        
    }
}
