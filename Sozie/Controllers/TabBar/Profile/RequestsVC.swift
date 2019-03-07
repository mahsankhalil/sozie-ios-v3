//
//  RequestsVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class RequestsVC: UIViewController {
    var reuseableIdentifier = "RequestTableViewCell"
    @IBOutlet weak var searchCountLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    var serverParams: [String: Any] = [String: Any]()
    var viewModels: [MyRequestCellViewModel] = []
    var selectedProduct: Product?
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
                var brandImageURL = ""
                if let brandId = request.requestedProduct.brandId {
                    if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                        brandImageURL = brand.titleImage
                    }
                }
                var searchPrice = 0.0
                if let price = request.requestedProduct.searchPrice {
                    searchPrice = Double(price)
                }
                var priceString = ""
                if let currency = request.requestedProduct.currency?.getCurrencySymbol() {
                    priceString = currency + " " + String(format: "%0.2f", searchPrice)
                }

                let viewModel = MyRequestCellViewModel(price: priceString, titleImageURL: URL(string: brandImageURL), imageURL: URL(string: imageURL), title: request.requestedProduct.productName, attributedTitle: nil, isSelected: request.isFilled, subtitle: "Size Requested: " + request.sizeValue)
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
    var nextURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requests.removeAll()
        getMyRequestsFromServer(dataDict: [:])
    }

    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            getMyRequestsFromServer(dataDict: serverParams)
        } else {
            serverParams.removeValue(forKey: "next")
            tableView.bottomRefreshControl?.endRefreshing()
        }
    }
    func getMyRequestsFromServer(dataDict: [String: Any]) {

        ServerManager.sharedInstance.getMyRequests(params: dataDict) { (isSuccess, response) in
            self.tableView.bottomRefreshControl?.endRefreshing()
            if isSuccess {
                let paginatedData = response as! RequestsPaginatedResponse
                self.requests.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                self.searchCountLabel.text = String(paginatedData.count) + " Requests"
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
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let popUpInstnc: PopupNavController? = PopupNavController.instance(type: nil, brandList: nil, filterType: FilterType.request )
        popUpInstnc?.popupDelegate = self
        let popUpVC = PopupController
            .create(self.tabBarController!)
        let options = PopupCustomOption.layout(.bottom)
        popUpVC.cornerRadius = 0.0
        _ = popUpVC.customize([options])
        _ = popUpVC.show(popUpInstnc!)
        popUpInstnc!.navigationHandler = { []  in
            UIView.animate(withDuration: 0.6, animations: {
                popUpVC.updatePopUpSize()
            })
        }
        popUpInstnc?.closeHandler = { [] in
            popUpVC.dismiss()
        }
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        requests.removeAll()
        getMyRequestsFromServer(dataDict: [:])
    }
    
}
extension RequestsVC: UITableViewDelegate, UITableViewDataSource {

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
        if let currentCell = cell as? RequestTableViewCell {
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
extension RequestsVC: RequestTableViewCellDelegate {
    func buyButtonTapped(button: UIButton) {
        let currentProduct = requests[button.tag].requestedProduct
        if let productURL = currentProduct.deepLink {
            guard let url = URL(string: productURL) else { return }
            UIApplication.shared.open(url)
        }
    }
}
extension RequestsVC: PopupNavControllerDelegate {
    func doneButtonTapped(type: FilterType?, id: Int?) {
        requests.removeAll()
        if let filterType = type {
            if filterType == FilterType.request {
                if let typeId = id {
                    if typeId == 0 {
                        serverParams["is_filled"] = true
                    } else {
                        serverParams["is_filled"] = false
                    }
                }
            }
        }
        serverParams.removeValue(forKey: "next")
        crossButton.isHidden = false
        getMyRequestsFromServer(dataDict: serverParams)
    }
}
