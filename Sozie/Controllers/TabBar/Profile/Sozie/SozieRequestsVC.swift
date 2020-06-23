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
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var instructionsHeightConstraint: NSLayoutConstraint!
    var reuseableIdentifier = "SozieRequestTableViewCell"
    var reuseableIdentifierTarget = "TargetRequestTableViewCell"
    @IBOutlet weak var searchBySizeButton: UIButton!
    @IBOutlet weak var searchByIdButton: UIButton!
    @IBOutlet weak var searchOptionsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var searchCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var questionMarkButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
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
    var totalTutorialCount: Float = 8.0
    var gstrRcgnzr: UIGestureRecognizer?
    var searchString: String?
    var searchType: String?
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
        self.tableView.backgroundColor = UIColor.white
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(loadNextPage), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        let topRefreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        topRefreshControl.triggerVerticalOffset = 50.0
        topRefreshControl.addTarget(self, action: #selector(reloadRequestData), for: .valueChanged)
        tableView.refreshControl = topRefreshControl
        instructionsHeightConstraint.constant = (860.0/375.0) * UIScreen.main.bounds.size.width
//        if UserDefaultManager.getIfRequestTutorialShown() == false {
//            tutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "SozieRequestTutorialVC") as! SozieRequestTutorialVC)
//            tutorialVC?.delegate = self
//            UIApplication.shared.keyWindow?.addSubview((tutorialVC?.view)!)
//        }
        showPostTutorials()
        NotificationCenter.default.addObserver(self, selector: #selector(resetFirstTime), name: Notification.Name(rawValue: "ResetFirstTime"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData), name: Notification.Name(rawValue: "PostUploaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showInstructions), name: Notification.Name(rawValue: "ShowInstructions"), object: nil)
//        self.view.window?.addSubview(tutorialVC.view)
        if let user = UserDefaultManager.getCurrentUserObject() {
            if user.country == 1 {
                self.totalTutorialCount = 7
            } else {
                self.totalTutorialCount = 8
            }
        }
        searchTextField.delegate = self
        searchViewHeightConstraint.constant = 0.0
        searchOptionsViewHeightConstraint.constant = 0.0
        self.reloadAllData()
    }
    @objc func resetFirstTime() {
        serverParams.removeAll()
        requests.removeAll()
        progressTutorialVC = nil
        self.ifInStockTutorialShown = false
        ifAcceptRequestTutorialShown = false
        ifUploadPostTutorialShown = false
        SVProgressHUD.show()
        self.fetchAllSozieRequests()
    }
    func disableRootButtons() {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            profileParentVC.navigationController?.navigationBar.isUserInteractionEnabled = false
            profileParentVC.tabViewController?.tabView.isUserInteractionEnabled = false
        }
//        ((self.parent as! ProfileTabsPageVC).view.subviews.compactMap { $0 as? UIScrollView }.first as! UIScrollView).isScrollEnabled = false
        if let parent = self.parent as? ProfileTabsPageVC {
            let scrollView = parent.view.subviews.compactMap { $0 as? UIScrollView }.first
            scrollView!.isScrollEnabled = false
        }
    }
    func enableRootButtons() {
        if let profileParentVC = self.parent?.parent as? ProfileRootVC {
            profileParentVC.navigationController?.navigationBar.isUserInteractionEnabled = true
            profileParentVC.tabViewController?.tabView.isUserInteractionEnabled = true

        }
        if let parent = self.parent as? ProfileTabsPageVC {
            let scrollView = parent.view.subviews.compactMap { $0 as? UIScrollView }.first
            scrollView!.isScrollEnabled = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.refreshControl?.didMoveToSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        serverParams.removeAll()
//        requests.removeAll()
//        fetchAllSozieRequests()
        hideAllSearchViews()
    }
    @objc func reloadAllData() {
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
                tutVC.view.frame.origin.y = (0.0)
                tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 50.0 + (topPadding ?? 0))
                let formattedString = NSMutableAttributedString()
                formattedString.bold("Required Tutorial\nComplete from home in your own clothes.")
//                formattedString.bold("Required Tutorial", size: 15.0).normal(": Follow arrow prompts below")
                tutVC.updateProgressTitle(string: formattedString)
                window?.addSubview(tutVC.view)
            }
        }
    }
    func showInStockTutorial() {
        if ifInStockTutorialShown == false {
            self.showProgressTutorial()
            progressTutorialVC?.updateProgress(progress: 1.0/totalTutorialCount)
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                inStockTutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "RequestInStockTutorialVC") as! RequestInStockTutorialVC)
                if let tutVC = inStockTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    self.questionMarkButton.isUserInteractionEnabled = false
                    self.searchButton.isUserInteractionEnabled = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.acceptButton.isEnabled = false
                        cell.pictureButton.isEnabled = false
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 365 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 365 + (topPadding ?? 0)
                    profileParentVC.view.addSubview(tutVC.view)
                    ifInStockTutorialShown = true
                    isFromTutorial = true
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
                acceptRequestTutorialVC?.descriptionString = "Click on     ACCEPT REQUEST    "
                progressTutorialVC?.updateProgress(progress: 4.0/totalTutorialCount)
                if let tutVC = acceptRequestTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    self.questionMarkButton.isUserInteractionEnabled = false
                    self.searchButton.isUserInteractionEnabled = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.checkStoresButton.isEnabled = false
                        cell.acceptButton.isEnabled = true
                        cell.pictureButton.isEnabled = false
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 345 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 345 + (topPadding ?? 0)
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
            cell.pictureButton.isEnabled = true
        }
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = true
    }
    func showUploadPostTutorial() {
        if ifUploadPostTutorialShown == false {
            if let profileParentVC = self.parent?.parent as? ProfileRootVC {
                acceptRequestTutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "AcceptRequestTutorialVC") as! AcceptRequestTutorialVC)
                progressTutorialVC?.updateProgress(progress: 5.0/totalTutorialCount)
                acceptRequestTutorialVC?.descriptionString = "Now let's fulfil the request!  When live, you will have 24 hours to do this but for now click on\n    UPLOAD PICTURE    "
                if let tutVC = acceptRequestTutorialVC {
                    disableRootButtons()
                    self.tableView.isScrollEnabled = false
                    self.tableView.allowsSelection = false
                    self.questionMarkButton.isUserInteractionEnabled = false
                    self.searchButton.isUserInteractionEnabled = false
                    if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TargetRequestTableViewCell {
                        cell.checkStoresButton.isEnabled = false
                        cell.acceptButton.isEnabled = true
                        cell.pictureButton.isEnabled = false
                    }
                    let window = UIApplication.shared.keyWindow
                    let topPadding = window?.safeAreaInsets.top
                    tutVC.view.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 365 - (topPadding ?? 0))
                    tutVC.view.frame.origin.x = 0
                    tutVC.view.frame.origin.y = 345 + (topPadding ?? 0)
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
            cell.pictureButton.isEnabled = true
        }
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = true
        self.questionMarkButton.isUserInteractionEnabled = true
        self.searchButton.isUserInteractionEnabled = true
    }
    @objc func reloadRequestData() {
        self.requests.removeAll()
        serverParams.removeAll()
        SVProgressHUD.show()
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
        if UserDefaultManager.getIfPostTutorialShown() == false {
            serverParams["is_tutorial_request"] = true
        }
        if searchString != nil && searchString != "" {
            serverParams["search_value"] = searchString
        }
        if searchType != nil && searchType != "" {
            serverParams["search_field"] = searchType
        }
        ServerManager.sharedInstance.getSozieRequest(params: serverParams) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            self.tableView.bottomRefreshControl?.endRefreshing()
            self.tableView.refreshControl?.endRefreshing()
            if isSuccess {
                let paginatedData = response as! RequestsPaginatedResponse
                self.requests.append(contentsOf: paginatedData.results)
                self.nextURL = paginatedData.next
                if self.requests.count > 0 {
                    let brandId = self.requests[0].brandId
                    let brand = UserDefaultManager.getBrandWithId(brandId: brandId)
                    self.searchCountLabel.text = String(paginatedData.count) + (paginatedData.count <= 1 ? " REQUEST" : " REQUESTS") + " BY " + (brand?.label.uppercased() ?? "")
                } else {
                    self.searchCountLabel.text = String(paginatedData.count) + (paginatedData.count <= 1 ? " REQUEST" : " REQUESTS")
                }
                self.showPostTutorials()
            }
        }
    }
    func populateDummyRequests() {
        if self.requests.count == 0 {
            if var user = UserDefaultManager.getCurrentUserObject() {
                user.isSuperUser = true
                let dummyProduct = Product(productId: 49263387, productName: "Women's Plus Size Sleeveless Square Neck Denim Dress - Universal Thread Indigo X, Blue", brandId: 10, imageURL: "https://target.scene7.com/is/image/Target/GUEST_bd675863-a930-4bf2-b855-c342457004e4?wid=1000&hei=1000", description: "Look effortlessly chic while keeping your cool for any occasion wearing this Sleeveless Square-Neck Denim Dress from Universal Thread. This indigo midi dress comes with a front tie that lets you find your ideal fit, and it's cut in a relaxed silhouette for comfortable wear. In a sleeveless design made from a 100 percent cotton fabric with side slits, this sleeveless denim midi dress keeps you feeling airy, light and comfy throughout your day. Pair it with espadrilles and a straw bucket bag for a casual day out or with strappy heels and drop earrings for a nighttime twist. Size: X. Color: Blue. Gender: Female. Age Group: Adult.", merchantProductId: "54441283", productStringId: "bd675863a9304bf2b855c342457004e4", searchPrice: 32.99, currency: "USD", merchantImageURL: "")
                let dummyRequest = SozieRequest(requestId: 700, user: user, sizeValue: "3x", productId: "bd675863a9304bf2b855c342457004e4", requestedProduct: dummyProduct, brandId: 10, isFilled: false, isAccepted: false, acceptedRequest: nil, color: nil, displaySize: "3x")
                self.requests.append(dummyRequest)
                self.requests.append(dummyRequest)
                self.requests.append(dummyRequest)

            }
        }
    }
    func showPostTutorials() {
        if UserDefaultManager.getIfPostTutorialShown() == false {
//            if UserDefaultManager.getIfRequestTutorialShown() {
            populateDummyRequests()
            self.showInStockTutorial()
            if let tabBarContrlr = self.parent?.parent?.parent?.parent as? TabBarVC {
//                tabBarContrlr.tabBar.isUserInteractionEnabled = false
                if let firstItem = tabBarContrlr.tabBar.items?[0], let secondItem = tabBarContrlr.tabBar.items?[1], let thirdItem = tabBarContrlr.tabBar.items?[2] {
                    firstItem.isEnabled = false
                    secondItem.isEnabled = false
                    thirdItem.isEnabled = false
//                    fourthItem.isEnabled = false
                }
            }
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
    func showSearchVu() {
        searchViewHeightConstraint.constant = 0.0
        gstrRcgnzr = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gstrRcgnzr?.cancelsTouchesInView = true
        self.view.addGestureRecognizer(gstrRcgnzr!)
        UIView.animate(withDuration: 0.3) {
            self.searchViewHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchView.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
            self.searchTextField.becomeFirstResponder()
        }
    }
    @objc func dismissKeyboard() {
//        self.view.endEditing(true)
        self.searchTextField.text = ""
        self.hideSearchVu()
        if let rcgnizer = gstrRcgnzr {
            self.view.removeGestureRecognizer(rcgnizer)
        }
    }
    func hideSearchVu() {
        if searchTextField.text?.isEmpty == false {
            crossButton.isHidden = false
            searchString = searchTextField.text
//            self.isFirstPage = true
//            self.clearFilterButton.isHidden = false
        } else {
            crossButton.isHidden = true
            searchString = nil
        }
        self.requests.removeAll()
        serverParams.removeAll()
        self.tableView.refreshControl?.beginRefreshing()
        fetchAllSozieRequests()
        searchViewHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchViewHeightConstraint.constant = 0.0
            self.searchView.clipsToBounds = true
            self.view.endEditing(true)
            if let rcgnizer = self.gstrRcgnzr {
                self.view.removeGestureRecognizer(rcgnizer)
            }
            self.view.layoutIfNeeded()
        }
    }
    func showSearchOptionView() {
        self.searchOptionsViewHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.searchOptionsViewHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchOptionsView.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
        }
    }
    func hideSearchOptionView() {
        searchOptionsViewHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchOptionsViewHeightConstraint.constant = 0.0
            self.searchOptionsView.clipsToBounds = true
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        self.requests.removeAll()
        serverParams.removeAll()
        searchString = nil
        self.tableView.refreshControl?.beginRefreshing()
        fetchAllSozieRequests()
        self.crossButton.isHidden = true
    }
    @IBAction func gotItButtonTapped(_ sender: Any) {
        instructionsScrollView.isHidden = true
        enableRootButtons()
        if ifGotItButtonTapped == false {
            showPostTutorials()
            ifGotItButtonTapped = true
        }
    }
    @IBAction func searchBySizeButtonTapped(_ sender: Any) {
        let popUpInstnc = SearchBySizePopUpVC.instance()
        popUpInstnc.delegate = self
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc)
        let options = PopupCustomOption.layout(.bottom)
        _ = popUpVC.customize([options])
        _ = popUpVC.didCloseHandler { (_) in
        }
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
       }
    }

    @IBAction func searchByIdButtonTapped(_ sender: Any) {
        searchType = "article_id"
        hideSearchOptionView()
        showSearchVu()
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        if searchOptionsViewHeightConstraint.constant == 0 && searchViewHeightConstraint.constant == 0 {
            showSearchOptionView()
        } else if searchOptionsViewHeightConstraint.constant == 47.0 && searchViewHeightConstraint.constant == 0 {
            hideSearchOptionView()
        } else if searchViewHeightConstraint.constant == 47.0 && searchOptionsViewHeightConstraint.constant == 0.0 {
            hideSearchVu()
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
extension SozieRequestsVC: SizeSelectionDelegate {
    func doneButtonTapped(selectedSizes: [String]) {
        var string = ""
        for size in selectedSizes {
            string = string + size.lowercased() + " "
        }
        string.removeLast()
        searchType = "size"
        searchString = string
        crossButton.isHidden = false
        hideSearchOptionView()
        self.requests.removeAll()
        serverParams.removeAll()
        self.tableView.refreshControl?.beginRefreshing()
        fetchAllSozieRequests()
    }
}
extension SozieRequestsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        var identifier = reuseableIdentifier
        if viewModel.brandId == 10 || viewModel.brandId == 18 {
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
            if isFromTutorial {
                currentCell.cancelButton.isUserInteractionEnabled = false
            } else {
                currentCell.cancelButton.isUserInteractionEnabled = true
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedProduct = requests[indexPath.row].requestedProduct
//        if (viewModels[indexPath.row].acceptedBySomeoneElse == false && viewModels[indexPath.row].isSelected == true) || viewModels[indexPath.row].isSelected == false {
//            if (tableView.cellForRow(at: indexPath) as? TargetRequestTableViewCell) != nil {
//                let cell = (tableView.cellForRow(at: indexPath) as? TargetRequestTableViewCell)
//                let button = cell?.acceptButton
//                self.acceptRequestButtonTapped(button: button!)
//            }
//        }
//        if viewModels[indexPath.row].acceptedBySomeoneElse == false && viewModels[indexPath.row].isSelected == true {
//            performSegue(withIdentifier: "toProductDetail", sender: self)
//        } else if viewModels[indexPath.row].isSelected == false {
//            performSegue(withIdentifier: "toProductDetail", sender: self)
//        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (requests.count < 10 && indexPath.row == requests.count - 2) || (indexPath.row == requests.count - 10) {
            loadNextPage()
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension SozieRequestsVC: SozieRequestTableViewCellDelegate {
    func hideAllSearchViews() {
        searchType = nil
        searchString = nil
        searchViewHeightConstraint.constant = 0.0
        searchOptionsViewHeightConstraint.constant = 0.0
        self.view.layoutIfNeeded()
        self.searchOptionsView.clipsToBounds = true
    }
    func pictureButtonTapped(button: UIButton) {
        selectedProduct = requests[button.tag].requestedProduct
        if viewModels[button.tag].acceptedBySomeoneElse == false && viewModels[button.tag].isSelected == true {
            performSegue(withIdentifier: "toProductDetail", sender: self)
        } else if viewModels[button.tag].isSelected == false {
            performSegue(withIdentifier: "toProductDetail", sender: self)
        }
        searchType = nil
        searchString = nil
        searchViewHeightConstraint.constant = 0.0
        searchOptionsViewHeightConstraint.constant = 0.0
        self.view.layoutIfNeeded()
    }
    func cancelRequestButtonTapped(button: UIButton) {
        UtilityManager.showMessageWith(title: "Warning!", body: "Are you sure you want to cancel this request? Cancelling will result in a strike against you.", in: self, okBtnTitle: "Ok", cancelBtnTitle: "Cancel", dismissAfter: nil) {
            self.cancelRequest(button: button)
        }
        hideAllSearchViews()
    }
    func cancelRequest(button: UIButton) {
        let currentRequest = self.requests[button.tag]
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
                    SVProgressHUD.show()
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.fetchUserDetail()
                    self.fetchAllSozieRequests()
                }
            }
        }
    }
    func nearByStorButtonAction(button: UIButton) {
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
        } else {
            if let img = product.imageURL {
                imageURL = img.getActualSizeImageURL() ?? ""
            }
        }
        if let merchantId = currentRequest.requestedProduct.merchantProductId?.components(separatedBy: " ")[0] {
            if currentRequest.brandId == 10 {
                self.showTargetStore(merchantId: merchantId, imageURL: imageURL)
            } else if currentRequest.brandId == 18 {
                self.showAdidasStoresPopup(productId: merchantId, imageURL: imageURL, sku: currentRequest.sku ?? "")
            }
        }
    }
    func showTargetStore(merchantId: String, imageURL: String) {
        let popUpInstnc = StoresPopupVC.instance(productId: merchantId, productImage: imageURL, progreesVC: progressTutorialVC)
        popUpInstnc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
        _ = popUpVC.show(popUpInstnc)
        popUpInstnc.closeHandler = { [] in
            popUpVC.dismiss()
            if UserDefaultManager.getIfPostTutorialShown() == false {
                self.showAcceptRequestTutorial()
            }
        }
    }
    func showAdidasStoresPopup(productId: String, imageURL: String, sku: String) {
        let popUpInstnc = StoresPopupListingVC.instance(productId: productId, productImage: imageURL, sku: sku, progreesVC: progressTutorialVC)
        popUpInstnc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
        _ = popUpVC.show(popUpInstnc)
        popUpInstnc.closeHandler = { [] in
            popUpVC.dismiss()
            if UserDefaultManager.getIfPostTutorialShown() == false {
                self.showAcceptRequestTutorial()
            }
        }
    }
    func nearbyStoresButtonTapped(button: UIButton) {
        if UserDefaultManager.getIfPostTutorialShown() == true {
            UtilityManager.showMessageWith(title: "Covid-19 Update", body: "We have paused in-store operations until further notice. Please stay safe at home", in: self)
            return
        }
        if let userId = UserDefaultManager.getCurrentUserId() {
            SVProgressHUD.show()
            ServerManager.sharedInstance.getUserProfile(userId: userId) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    let user = response as! User
                    UserDefaultManager.updateUserObject(user: user)
                    if user.isTutorialApproved == false {
                        if self.isFromTutorial {
                            self.nearByStorButtonAction(button: button)
                        }
                        return
                    } else {
                        self.nearByStorButtonAction(button: button)
                    }
                }
            }
        }
        hideAllSearchViews()
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
            if let user = UserDefaultManager.getCurrentUserObject() {
                if user.isBanned == true {
                    UtilityManager.showMessageWith(title: "Oops!", body: "You have been banned from Sozie for having 2 strikes against you.\nAny of the following reason results in a strike:\n- Cancelling an accepted request\n- Not completing an accepted request within 24 hours\n- Having a completed request rejected\n We have sent you an email with more details", in: self, leftAligned: true)
                    return
                }
            }
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
            if self.isFromTutorial == true {
                self.acceptDumnyRequest(tag: button.tag)
                self.hideAcceptRequestTutorial()
                self.showUploadPostTutorial()
                return
            } else {
                UtilityManager.showMessageWith(title: "Are you sure you want to accept this request?", body: "If you do not complete the request, a strike will be counted against you.", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                    UtilityManager.showMessageWith(title: "Are you a part of Sozie@Home?", body: "Only accept if you are part of our Sozie@Home program. In-store operations are paused until further notice.", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                        self.acceptRequestAPICall(tag: button.tag)
                    }
                }
            }
        }
        hideAllSearchViews()
    }
    func makeRequestAccepted(tag: Int, acceptedRequest: AcceptedRequest) {
        requests[tag].isAccepted = true
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormat.timeZone = TimeZone(abbreviation: "UTC")
//        let calendar = Calendar.current
//        let date = calendar.date(byAdding: .hour, value: 24, to: Date())
//        let acceptedRequest = AcceptedRequest(acceptedById: UserDefaultManager.getCurrentUserId()!, acceptedId: acceptedRequestId, expiry: dateFormat.string(from: date!))
        requests[tag].acceptedRequest = acceptedRequest
        let viewModel = SozieRequestCellViewModel(request: requests[tag])
        viewModels.remove(at: tag)
        viewModels.insert(viewModel, at: tag)
        self.tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
    }
    func acceptRequestAPICall(tag: Int) {
        SVProgressHUD.show()
        var dataDict = [String: Any]()
        dataDict["product_request"] = currentRequest?.requestId
        ServerManager.sharedInstance.acceptRequest(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
//                self.serverParams.removeAll()
//                self.requests.removeAll()
//                SVProgressHUD.show()
//                self.fetchAllSozieRequests()
                let acceptedRequestResponse = response as! AcceptedRequestResponse
                self.makeRequestAccepted(tag: tag, acceptedRequest: acceptedRequestResponse.acceptedRequest)
            } else {
                let error = (response as! Error).localizedDescription
                if let errorDict = error.getColonSeparatedErrorDetails() {
                    if let title = errorDict["title"] as? String, let description = errorDict["description"] as? String {
                        if title == "Tutorial Rejected" {
                            UserDefaultManager.makeUserGuideEnable()
                            UserDefaultManager.removeAllUserGuidesShown()
                            self.showResetTutorialPopup(text: description)
                        } else if title == "Oops!" {
                            UtilityManager.showMessageWith(title: title, body: description, in: self, leftAligned: true)
                        } else {
                            UtilityManager.showMessageWith(title: title, body: description, in: self)
                        }
                    } else {
                        UtilityManager.showMessageWith(title: "Error!", body: (response as! Error).localizedDescription, in: self)
                    }
                } else {
                    UtilityManager.showMessageWith(title: "Error!", body: (response as! Error).localizedDescription, in: self)
                }
            }
        }
    }
    func showResetTutorialPopup(text: String) {
        let popUpInstnc = SozieRequestErrorPopUp.instance(description: text)
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc)
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
        popUpInstnc.resetTutorialHandler = { [] in
            popUpVC.dismiss()
            self.resetFirstTime()
        }
    }
    @objc func showInstructions() {
        tutorialVC?.view.removeFromSuperview()
        instructionsScrollView.isHidden = false
        disableRootButtons()
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
        showInstructions()
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
        self.questionMarkButton.isUserInteractionEnabled = true
        self.searchButton.isUserInteractionEnabled = true
        serverParams.removeAll()
        requests.removeAll()
        SVProgressHUD.show()
        fetchAllSozieRequests()
    }
}
extension SozieRequestsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        hideSearchVu()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchVu()
        return true
    }
}
