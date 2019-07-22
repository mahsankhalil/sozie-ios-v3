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
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var instructionsHeightConstraint: NSLayoutConstraint!
    var reuseableIdentifier = "SozieRequestTableViewCell"
    var reuseableIdentifierTarget = "TargetRequestTableViewCell"
    @IBOutlet weak var searchCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var questionMarkButton: UIButton!
    @IBOutlet weak var instructionsScrollView: UIScrollView!
    var nextURL: String?
    var viewModels: [SozieRequestCellViewModel] = []
    var selectedProduct: Product?
    var serverParams: [String: Any] = [String: Any]()
    var currentRequest: SozieRequest?
    var tutorialVC: SozieRequestTutorialVC?
    var inStockTutorialVC: RequestInStockTutorialVC?
    var acceptRequestTutorialVC: AcceptRequestTutorialVC?
    var ifInStockTutorialShown: Bool = false
    var ifAcceptRequestTutorialShown: Bool = false
    var ifUploadPostTutorialShown: Bool = false
    var isFromTutorial: Bool = false
    var progressTutorialVC: TutorialProgressVC?
    var ifGotItButtonTapped: Bool = false
    var requests: [SozieRequest] = [] {
        didSet {
            viewModels.removeAll()
            for request in requests {
                let viewModel = SozieRequestCellViewModel(request: request)
                viewModels.append(viewModel)
            }
            noDataLabel.isHidden = viewModels.count != 0
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
        let topRefreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        topRefreshControl.triggerVerticalOffset = 50.0
        topRefreshControl.addTarget(self, action: #selector(reloadRequestData), for: .valueChanged)
        tableView.refreshControl = topRefreshControl
        instructionsHeightConstraint.constant = (1713.0/375.0) * UIScreen.main.bounds.size.width
//        if UserDefaultManager.getIfRequestTutorialShown() == false {
//            tutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "SozieRequestTutorialVC") as! SozieRequestTutorialVC)
//            tutorialVC?.delegate = self
//            UIApplication.shared.keyWindow?.addSubview((tutorialVC?.view)!)
//        }
        showPostTutorials()
        NotificationCenter.default.addObserver(self, selector: #selector(resetFirstTime), name: Notification.Name(rawValue: "ResetFirstTime"), object: nil)
//        self.view.window?.addSubview(tutorialVC.view)

    }
    @objc func resetFirstTime() {
        serverParams.removeAll()
        requests.removeAll()
        self.fetchAllSozieRequests()
    }
    func disableRootButtons() {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {

            profileParentVC.navigationController?.navigationBar.isUserInteractionEnabled = false
            profileParentVC.tabViewController?.tabView.isUserInteractionEnabled = false
        }
    }
    func enableRootButtons() {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            profileParentVC.navigationController?.navigationBar.isUserInteractionEnabled = true
            profileParentVC.tabViewController?.tabView.isUserInteractionEnabled = true

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.refreshControl?.didMoveToSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverParams.removeAll()
        requests.removeAll()
        fetchAllSozieRequests()
    }
    func showProgressTutorial() {
        if progressTutorialVC == nil {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            progressTutorialVC = self.storyboard?.instantiateViewController(withIdentifier: "TutorialProgressVC") as? TutorialProgressVC
            progressTutorialVC?.delegate = self
            if let tutVC = progressTutorialVC {
                tutVC.view.frame.origin.y = 0
                tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: (topPadding ?? 0.0) + 64.0)
                window?.addSubview(tutVC.view)
            }
        }
    }
    func showInStockTutorial() {
        if ifInStockTutorialShown == false {
            self.showProgressTutorial()
            progressTutorialVC?.updateProgress(progress: 1.0/8.0)
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                inStockTutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "RequestInStockTutorialVC") as! RequestInStockTutorialVC)
                if let tutVC = inStockTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.acceptButton.isEnabled = false
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 365 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 365 + (topPadding ?? 0)
                    profileParentVC.view.addSubview(tutVC.view)
                    ifInStockTutorialShown = true
                }
            }
        }
    }
    func hideInStockTutorial() {
        inStockTutorialVC?.view.removeFromSuperview()
        enableRootButtons()
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
            cell.checkStoresButton.isEnabled = true
            cell.acceptButton.isEnabled = true
        }
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = true
    }
    func showAcceptRequestTutorial() {
        if ifAcceptRequestTutorialShown == false {
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                acceptRequestTutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "AcceptRequestTutorialVC") as! AcceptRequestTutorialVC)
                progressTutorialVC?.updateProgress(progress: 4.0/8.0)
                if let tutVC = acceptRequestTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.checkStoresButton.isEnabled = false
                        cell.acceptButton.isEnabled = true
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 365 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 365 + (topPadding ?? 0)
                    profileParentVC.view.addSubview(tutVC.view)
                    ifAcceptRequestTutorialShown = true
                    isFromTutorial = true
                }
            }
        }
    }
    func hideAcceptRequestTutorial() {
        acceptRequestTutorialVC?.view.removeFromSuperview()
        enableRootButtons()
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
            cell.checkStoresButton.isEnabled = true
            cell.acceptButton.isEnabled = true
        }
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = true
    }
    func showUploadPostTutorial() {
        if ifUploadPostTutorialShown == false {
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                acceptRequestTutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "AcceptRequestTutorialVC") as! AcceptRequestTutorialVC)
                progressTutorialVC?.updateProgress(progress: 5.0/8.0)
                acceptRequestTutorialVC?.descriptionString = "Now let's fulfill the request.\nYou have 12 hours. Click here"
                if let tutVC = acceptRequestTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.checkStoresButton.isEnabled = false
                        cell.acceptButton.isEnabled = true
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 365 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 365 + (topPadding ?? 0)
                    profileParentVC.view.addSubview(tutVC.view)
                    ifUploadPostTutorialShown = true
                }
            }
        }
    }
    func hideUploadPostTutorial() {
        acceptRequestTutorialVC?.view.removeFromSuperview()
        enableRootButtons()
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
            cell.checkStoresButton.isEnabled = true
            cell.acceptButton.isEnabled = true
        }
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = true
    }
    @objc func reloadRequestData() {
        self.requests.removeAll()
        serverParams.removeAll()
        fetchAllSozieRequests()
    }
    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            fetchAllSozieRequests()
        } else {
            serverParams.removeValue(forKey: "next")
            tableView.bottomRefreshControl?.endRefreshing()
        }
    }

    func fetchAllSozieRequests() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getSozieRequest(params: serverParams) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            self.tableView.bottomRefreshControl?.endRefreshing()
            self.tableView.refreshControl?.endRefreshing()
            if isSuccess {
                let paginatedData = response as! RequestsPaginatedResponse
                self.requests.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                self.searchCountLabel.text = String(paginatedData.count) + (paginatedData.count <= 1 ? " REQUEST" : " REQUESTS")
                self.showPostTutorials()
            }
        }
    }
    func showPostTutorials() {
        if UserDefaultManager.getIfPostTutorialShown() == false {
//            if UserDefaultManager.getIfRequestTutorialShown() {
                self.showInStockTutorial()
                if let tutorialView = self.acceptRequestTutorialVC?.view {
                    if let parentView = self.parent?.parent?.view {
                        if tutorialView.isDescendant(of: parentView) && self.ifUploadPostTutorialShown == true {
                            self.acceptDumnyRequest(tag: 0)
                        }
                    }
                }
//            }
        }

    }
    @IBAction func gotItButtonTapped(_ sender: Any) {
        instructionsScrollView.isHidden = true
        enableRootButtons()
        if ifGotItButtonTapped == false {
            showPostTutorials()
            ifGotItButtonTapped = true
        }
    }

    @IBAction func questionMarkButtonTapped(_ sender: Any) {
        instructionsScrollView.isHidden = false
        disableRootButtons()
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
        var identifier = reuseableIdentifier
        if viewModel.brandId == 10 {
            identifier = reuseableIdentifierTarget
        }
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
        if let currentCell = cell as? SozieRequestTableViewCell {
            currentCell.delegate = self
        }
        if let currentCell = cell as? TargetRequestTableViewCell {
            currentCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = requests[indexPath.row].requestedProduct
        if viewModels[indexPath.row].acceptedBySomeoneElse == false && viewModels[indexPath.row].isSelected == true {
            performSegue(withIdentifier: "toProductDetail", sender: self)
        } else if viewModels[indexPath.row].isSelected == false {
            performSegue(withIdentifier: "toProductDetail", sender: self)
        }
    }
}
extension SozieRequestsVC: SozieRequestTableViewCellDelegate {
    func cancelRequestButtonTapped(button: UIButton) {
        let currentRequest = requests[button.tag]
        if let acceptedRequestId = currentRequest.acceptedRequest?.acceptedId {
            SVProgressHUD.show()
            ServerManager.sharedInstance.cancelRequest(requestId: acceptedRequestId) { (isSuccess, _) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? SozieRequestTableViewCell {
                        cell.timer?.invalidate()
                        cell.timer = nil
                    } else if let cell = self.tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? TargetRequestTableViewCell {
                        cell.timer?.invalidate()
                        cell.timer = nil
                    }
                    self.serverParams.removeAll()
                    self.requests.removeAll()
                    self.fetchAllSozieRequests()
                }
            }
        }
    }

    func nearbyStoresButtonTapped(button: UIButton) {
        hideInStockTutorial()
        let currentRequest = requests[button.tag]
        let product = currentRequest.requestedProduct
        var imageURL = ""
        if var prodImageURL = product.merchantImageURL {
            if prodImageURL == "" {
                if let imageURLTarget = product.imageURL {
                    imageURL = imageURLTarget
                }
            } else {
                if prodImageURL.contains("|") {
                    let delimeter = "|"
                    let url = prodImageURL.components(separatedBy: delimeter)
                    prodImageURL = url[0]
                }
                imageURL = prodImageURL
            }
        }
        if let merchantId = currentRequest.requestedProduct.merchantProductId?.components(separatedBy: " ")[0] {
            let popUpInstnc = StoresPopupVC.instance(productId: merchantId, productImage: imageURL, progreesVC: progressTutorialVC)
            popUpInstnc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            let popUpVC = PopupController
                .create(self.tabBarController!.navigationController!)
            //        let options = PopupCustomOption.layout(.bottom)
            //        popUpVC.cornerRadius = 0.0
            //        _ = popUpVC.customize([options])
            _ = popUpVC.show(popUpInstnc)
            popUpInstnc.closeHandler = { [] in
                popUpVC.dismiss()
                if UserDefaultManager.getIfPostTutorialShown() == false {
                    self.showAcceptRequestTutorial()
                }
            }
        }
    }
    func acceptDumnyRequest(tag: Int) {
        requests[tag].isAccepted = true
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormat.timeZone = TimeZone(abbreviation: "UTC")
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 24, to: Date())
        let acceptedRequest = AcceptedRequest(acceptedById: UserDefaultManager.getCurrentUserId()!, acceptedId: 0, expiry: dateFormat.string(from: date!))
        requests[tag].acceptedRequest = acceptedRequest
        let viewModel = SozieRequestCellViewModel(request: requests[tag])
        viewModels.remove(at: tag)
        viewModels.insert(viewModel, at: tag)
        self.tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
    }
    func acceptRequestButtonTapped(button: UIButton) {
        currentRequest = requests[button.tag]
        if currentRequest?.isAccepted == true {
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                if let uploadPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostAndFitTipsVC") as? UploadPostAndFitTipsVC {
                    uploadPostVC.currentRequest = currentRequest
                    if isFromTutorial {
                        if UserDefaultManager.getIfPostTutorialShown() == false {
                            uploadPostVC.isTutorialShowing = true
                        }
                    }
                    uploadPostVC.progressTutorialVC = progressTutorialVC
                    uploadPostVC.delegate = self
                    hideUploadPostTutorial()
                    isFromTutorial = false
                profileParentVC.navigationController?.pushViewController(uploadPostVC, animated: true)
                }
            }
        } else {
            if isFromTutorial {
                acceptDumnyRequest(tag: button.tag)
                hideAcceptRequestTutorial()
                showUploadPostTutorial()
                return
            }
            SVProgressHUD.show()
            var dataDict = [String: Any]()
            dataDict["product_request"] = currentRequest?.requestId
            ServerManager.sharedInstance.acceptRequest(params: dataDict) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.serverParams.removeAll()
                    self.requests.removeAll()
                    self.fetchAllSozieRequests()
                } else {
                    UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
                }
            }
        }
    }
}
extension SozieRequestsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uploadPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostVC") as? UploadPostVC {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                    let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 750, height: (pickedImage.size.height/pickedImage.size.width)*750))
                    uploadPostVC.currentRequest = currentRequest
                    uploadPostVC.selectedImage = scaledImg
                    profileParentVC.navigationController?.pushViewController(uploadPostVC, animated: true)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
extension SozieRequestsVC: SozieRequestTutorialDelegate {
    func infoButtonTapped() {
        tutorialVC?.view.removeFromSuperview()
        instructionsScrollView.isHidden = false
        disableRootButtons()
    }
}
extension SozieRequestsVC: UploadPostAndFitTipsDelegate {
    func uploadPostInfoButtonTapped() {
        if let tutVC = tutorialVC {
            tutVC.view.removeFromSuperview()
        }
        instructionsScrollView.isHidden = false
        disableRootButtons()
    }
}
extension SozieRequestsVC: TutorialProgressDelegate {
    func tutorialSkipButtonTapped() {
        self.hideInStockTutorial()
        self.hideUploadPostTutorial()
        self.hideAcceptRequestTutorial()
    }
}
