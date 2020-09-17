//
//  ProductDetailVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import EasyTipView
import SafariServices
import TPKeyboardAvoiding
class ProductDetailVC: BaseViewController {

    @IBOutlet weak var orderButton: DZGradientButton!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeToSeeView: UIView!
    @IBOutlet weak var heartButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestsTableView: UITableView!
    @IBOutlet weak var viewRequestsButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var mainScrollView: TPKeyboardAvoidingScrollView!
    
    var nextURL: String?
    var currentProduct: Product?
    var viewModels: [PostCellViewModel] = []
    var commentViewModels: [CommentsViewModel] = []
    var productViewModel = ProductDetailCellViewModel()
    var requestsViewModels: [SozieRequestCellViewModel] = []
    var reuseableIdentifier = "SozieRequestTableViewCell"
    var reuseableIdentifierTarget = "TargetRequestTableViewCell"
    var currentPostId: Int?
    @IBOutlet weak var bottomView: UIView!
    var tipView: EasyTipView?
    var tapGesture: UITapGestureRecognizer?
    var currentIndex: Int = 0
    var currentRequest: SozieRequest?
    var serverParams: [String: Any] = [String: Any]()
    var shoulScrollToRequests = false
    var requests: [SozieRequest] = [] {
        didSet {
            requestsViewModels.removeAll()
            for request in requests {
                let viewModel = SozieRequestCellViewModel(request: request)
                requestsViewModels.append(viewModel)
            }
            noDataLabel.isHidden = requestsViewModels.count != 0
            requestsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeToSeeView.roundCorners(corners: [.topLeft], radius: 20.0)
        setupSozieLogoNavBar()
        pageControl.currentPage = 0
//        populateProductData()
//        fetchProductDetailFromServer()
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(UINib(nibName: "ProductDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailCollectionViewCell")
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        tableViewHeightConstraint.constant = 400
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            topViewHeightConstraint.constant = UIScreen.main.bounds.size.height - topPadding! - bottomPadding! - (self.tabBarController?.tabBar.frame.height)! - (self.navigationController?.navigationBar.frame.height)! - 109
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken != nil {
//            self.showTagItemButton()
            self.showCancelButton()
        }
        self.fetchRequestsFromServer()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAllData), name: Notification.Name(rawValue: "PostUploaded"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductDetailFromServer()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken != nil {
            self.showTagThisItemViewAfterDelay()
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnScreen))
            self.view.addGestureRecognizer(tapGesture!)
        }
    }
    @objc func tappedOnScreen() {
        self.tagThisItemView?.removeFromSuperview()
        self.showSmallTagThisItemView()
        if tapGesture != nil {
            self.view.removeGestureRecognizer(tapGesture!)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLayoutSubviews() {
//        descriptionTextLabel.setContentOffset(.zero, animated: false)
    }
    @objc func loadNextPage() {
        if let nextUrl = self.nextURL {
            serverParams["next"] = nextUrl
            fetchRequestsFromServer()
        } else {
            serverParams.removeValue(forKey: "next")
            requestsTableView.bottomRefreshControl?.endRefreshing()
        }
    }
    @objc func reloadAllData() {
        serverParams.removeAll()
        requests.removeAll()
        fetchRequestsFromServer()
    }
    func fetchRequestsFromServer() {
        if let productId = currentProduct?.productStringId {
            serverParams["search_field"] = "product_id"
            serverParams["search_value"] = productId
            if let nextUrl = self.nextURL {
                serverParams["next"] = nextUrl
            }
            SVProgressHUD.show()
            ServerManager.sharedInstance.getSozieRequest(params: serverParams) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    let paginatedData = response as! RequestsPaginatedResponse
                    self.requests.append(contentsOf: paginatedData.results)
                    self.nextURL = paginatedData.next
                    if self.shoulScrollToRequests == true {
                        self.scrollToBottom()
                    }
                }

            }
        }
    }
    func fetchProductDetailFromServer() {
        if let productId = currentProduct?.productStringId {
            SVProgressHUD.show()
            ServerManager.sharedInstance.getProductDetail(productId: productId) { (isSuccess, response) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.updateCurrentProductObject(product: response as! Product)
                    self.populateProductData()
                }
            }
        }
    }
    func updateCurrentProductObject(product: Product) {
        currentProduct?.isFavourite = product.isFavourite
        currentProduct?.posts = product.posts
        currentProduct?.sizeChart = product.sizeChart
        currentProduct?.postCount = product.posts?.count
        currentProduct?.reviews = product.reviews
    }
    func populateProductData() {
        var priceString = ""
        var searchPrice = 0.0
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + String(format: "%0.2f", searchPrice)
        }
        priceLabel.text = priceString
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            descriptionTextLabel.text = productName + "\n" +  productDescription
//            descriptionTextView.setContentOffset(.zero, animated: true)
        }
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                productViewModel.titleImageURL = URL(string: brand.titleImage)
            }
        }
        assignImageURL()
        if currentProduct?.isFavourite == false {
            heartButton.setImage(UIImage(named: "Blank Heart"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "Filled Heart"), for: .normal)
        }
//        pageControl.currentPage = 0
        if let posts = currentProduct?.posts {
            if posts.count == 0 {
                swipeToSeeView.isHidden = true
                pageControl.isHidden = true
            } else {
                swipeToSeeView.isHidden = false
                pageControl.isHidden = false
            }
            pageControl.numberOfPages = posts.count + 1
        } else {
            pageControl.numberOfPages = 1
            swipeToSeeView.isHidden = true
            pageControl.isHidden = true
        }
//        updateCommentsView()
        makePostCellViewModel()
    }
    func assignImageURL() {
        if var imageURL = currentProduct?.merchantImageURL {
            if imageURL == "" || imageURL.count < 4 {
                if let imageURLTarget = currentProduct?.imageURL {
                    productViewModel.imageURL = URL(string: imageURLTarget)
                }
            } else {
                if imageURL.contains("|") {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
                productViewModel.imageURL = URL(string: imageURL)
            }
        } else if let imageURL = currentProduct?.imageURL {
            productViewModel.imageURL = URL(string: imageURL)
        }
    }
    func makePostCellViewModel() {
        viewModels.removeAll()
        var indexOfPost = currentIndex
        if let posts = currentProduct?.posts {
            var index = 0
            for post in posts {
                if post.postId == currentPostId {
                    indexOfPost = index + 1
                }
                let viewModel = PostCellViewModel(post: post)
                viewModels.append(viewModel)
                index = index + 1
            }
        }
        self.collectionView.reloadData()
        pageControl.numberOfPages = viewModels.count + 1
        self.pageControl.currentPage = indexOfPost
        currentIndex = indexOfPost
        if currentProduct?.posts?.count != 0 {
            if indexOfPost > 0 {
                swipeToSeeView.isHidden = true
            } else {
                swipeToSeeView.isHidden = false
            }
        }
        self.collectionView.scrollToItem(at: IndexPath(item: indexOfPost, section: 0), at: .centeredHorizontally, animated: false)
    }

    @objc func showSuccessPopUp() {
        var popUpInstnc: ServerResponsePopUp?
        popUpInstnc = ServerResponsePopUp.instance(imageName: "checked", title: "Request Sent", description: "Look out for filled requests in your profile.", height: 200, isOkButtonHidded: true)
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc!)
        popUpInstnc!.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: mainScrollView.contentSize.height - mainScrollView.bounds.size.height)
        mainScrollView.setContentOffset(bottomOffset, animated: true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toUploadPost" {
            let uploadPostVC = segue.destination as! UploadPostAndFitTipsVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            uploadPostVC.selectedImage = appDelegate.imageTaken
            uploadPostVC.currentProduct = currentProduct
        }
        if segue.identifier == "toWebVC" {
            let webVC = segue.destination as! WebVC
            if let link = currentProduct?.deepLink {
                webVC.url = URL(string: link)
            }
        }
        if segue.identifier == "toCommentsDetail" {
            let commentVC = segue.destination as! CommentsVC
            commentVC.currentProduct = currentProduct
            if let allPosts = currentProduct?.posts {
                if currentIndex != 0 {
                    commentVC.currentPost = allPosts[currentIndex - 1]
                }
            }
        }
    }
    // MARK: - Actions

    @IBAction func orderButtonTapped(_ sender: Any) {
        if let productURL = self.currentProduct?.deepLink {
            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            webVC.url = URL(string: productURL)
            webVC.modalPresentationStyle = .overFullScreen
            self.tabBarController?.navigationController?.present(webVC, animated: true, completion: nil)
        }
    }
    @IBAction func viewRequestsButtonTapped(_ sender: Any) {
        scrollToBottom()
    }
    @IBAction func heartButtonTapped(_ sender: Any) {
        if currentProduct?.isFavourite == false {
            if let productId = currentProduct?.productStringId {
                self.heartButton.setImage(UIImage(named: "Filled Heart"), for: .normal)
                var dataDict = [String: Any]()
                dataDict["user"] = UserDefaultManager.getCurrentUserId()
                dataDict["product_id"] = productId
                ServerManager.sharedInstance.favouriteProduct(params: dataDict) { (isSuccess, _) in

                    if isSuccess {
                        self.currentProduct?.isFavourite = true
                    }
                }
            }
        } else {
            if let productId = currentProduct?.productStringId {
                self.heartButton.setImage(UIImage(named: "Blank Heart"), for: .normal)
                ServerManager.sharedInstance.removeFavouriteProduct(productId: productId) { (isSuccess, _) in

                    if isSuccess {
                        self.currentProduct?.isFavourite = false
                    }
                }
            }
        }
    }
    override func tagItemButtonTapped() {
        self.tagThisItemView?.removeFromSuperview()
        self.smallTagThisItemView?.removeFromSuperview()
        self.performSegue(withIdentifier: "toUploadPost", sender: self)
    }
    override func cancelButtonTapped() {
        super.cancelButtonTapped()
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var viewModel: ReuseIdentifierProviding

        if indexPath.row == 0 {
            viewModel = productViewModel
        } else {
            viewModel = viewModels[indexPath.row - 1]
        }
        let collectionViewCell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath)
        guard let cell = collectionViewCell else { return UICollectionViewCell() }
        if let buttonProviderCell = cell as? ButtonProviding {
            buttonProviderCell.assignTagWith(indexPath.row)
        }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel as! RowViewModel)
        }
        if let postCollectionCell = cell as? PostCollectionViewCell {
            postCollectionCell.delegate = self
        }
        if let productCollectionCell = cell as? ProductDetailCollectionViewCell {
            productCollectionCell.delegate = self
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionView.frame.size.height)

    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension ProductDetailVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xAxis = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        let currentPage = Int(ceil(xAxis/width))
        if currentPage > currentProduct?.posts?.count ?? 0 {
            return
        }
        pageControl.currentPage = currentPage
        if let posts = currentProduct?.posts {
            if posts.count > 0 {
                swipeToSeeView.isHidden = currentPage > 0
            }
        }
        if currentPage == 0 {
            if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
                descriptionTextLabel.text = productName + "\n" +  productDescription
            }
        } else {
            if let fittips = currentProduct?.posts?[currentPage - 1].compiledFitTips {
                descriptionTextLabel.text = fittips
            }
        }
        currentIndex = currentPage
    }
    func getAttributedStringWith(name: String, text: String) -> NSAttributedString {
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "SegoeUI-Bold", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor(hex: "282828") ]
        let myString = NSMutableAttributedString(string: name + " ", attributes: myAttribute)
        let myAttributeText = [ NSAttributedString.Key.font: UIFont(name: "SegoeUI", size: 14.0)!, NSAttributedString.Key.foregroundColor: UIColor(hex: "A6A6A6") ]
        let myStringText = NSMutableAttributedString(string: text, attributes: myAttributeText)
        myString.append(myStringText)
        return myString
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tagThisItemView?.removeFromSuperview()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken != nil {
            self.showSmallTagThisItemView()
        }
    }
}
extension ProductDetailVC: PostCollectionViewCellDelegate {
    func profileButtonTapped(button: UIButton) {
//        if let posts = self.currentProduct?.posts {
//            let sozieProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "SozieProfileVC") as! SozieProfileVC
//            let currentUser = posts[button.tag - 1].user
//            currentPostId = posts[button.tag - 1].postId
//            sozieProfileVC.user = currentUser
//            self.navigationController?.pushViewController(sozieProfileVC, animated: true)
//        }
    }

    func cameraButtonTapped(button: UIButton) {
        UtilityManager.showMessageWith(title: "Coming Soon", body: "Tap \"Profile\" to see Requests available to you", in: self)
//        UtilityManager.openImagePickerActionSheetFrom(viewController: self)
    }

    func moreButtonTapped(button: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
            if let posts = self.currentProduct?.posts {
                let postId = posts[button.tag - 1].postId
                var dataDict = [String: Any]()
                dataDict["post"] = postId
                dataDict["user"] = UserDefaultManager.getCurrentUserId()
                SVProgressHUD.show()
                ServerManager.sharedInstance.reportPost(params: dataDict, block: { (isSuccess, _ ) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        UtilityManager.showMessageWith(title: "Thank you for reporting this post", body: "Our administration will remove the post if it violates Sozie terms and conditions.", in: self)
                    }
                })
            }
        }))

        alert.addAction(UIAlertAction(title: "Block", style: .default, handler: { _ in

            if let posts = self.currentProduct?.posts {
                UtilityManager.showMessageWith(title: "Block " + posts[button.tag - 1].user.username, body: "Are you sure you want to Block?", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", block: {
                    let userIdToBlock = posts[button.tag - 1].user.userId
                    var dataDict = [String: Any]()
                    dataDict["blocker"] = UserDefaultManager.getCurrentUserId()
                    dataDict["user"] = userIdToBlock
                    SVProgressHUD.show()
                    ServerManager.sharedInstance.blockUser(params: dataDict, block: { (_, _ ) in
                        self.fetchProductDetailFromServer()
                        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "RefreshBrowseData")))
                        SVProgressHUD.dismiss()

                    })
                })

            }
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func followButtonTapped(button: UIButton) {
        if let posts = currentProduct?.posts {
            var dataDict = [String: Any]()
            let userId = posts[button.tag - 1].user.userId
            dataDict["user"] = userId
            if self.viewModels[button.tag - 1].isFollow == true {
                SVProgressHUD.show()
                ServerManager.sharedInstance.unFollowUser(params: dataDict) { (isSuccess, _) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        self.currentProduct?.posts![button.tag - 1].userFollowedByMe = false
                        self.currentProduct?.posts![button.tag - 1].user.isFollowed = false
                        self.viewModels[button.tag - 1].isFollow = false
                        self.collectionView.reloadItems(at: [IndexPath(item: button.tag, section: 0)])
                    }
                }
            } else {
                SVProgressHUD.show()
                ServerManager.sharedInstance.followUser(params: dataDict) { (isSuccess, _) in
                    SVProgressHUD.dismiss()
                    if isSuccess {
                        self.currentProduct?.posts![button.tag - 1].userFollowedByMe = true
                        self.viewModels[button.tag - 1].isFollow = true
                        self.collectionView.reloadItems(at: [IndexPath(item: button.tag, section: 0)])
                    }
                }
            }
        }
    }
}
extension ProductDetailVC: ProductDetailCollectionViewCellDelegate {
    func productCameraButtonTapped(button: UIButton) {
        UtilityManager.showMessageWith(title: "Coming Soon", body: "Tap \"Profile\" to see Requests available to you", in: self)

//        UtilityManager.openImagePickerActionSheetFrom(viewController: self)
    }
}
extension ProductDetailVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uploadPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostAndFitTipsVC") as? UploadPostAndFitTipsVC {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let scaledImg = pickedImage.scaleImageToSize(newSize: CGSize(width: 750, height: (pickedImage.size.height/pickedImage.size.width)*750))
                uploadPostVC.selectedImage = scaledImg
                uploadPostVC.currentProduct = currentProduct
                self.navigationController?.pushViewController(uploadPostVC, animated: true)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = requestsViewModels[indexPath.row]
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
            currentCell.cancelButton.isUserInteractionEnabled = true
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

extension ProductDetailVC: SozieRequestTableViewCellDelegate {
    func pictureButtonTapped(button: UIButton) {

    }
    func cancelRequestButtonTapped(button: UIButton) {
//        UtilityManager.showMessageWith(title: "Warning!", body: "Are you sure you want to cancel this request? Cancelling will result in a strike against you.", in: self, okBtnTitle: "Ok", cancelBtnTitle: "Cancel", dismissAfter: nil) {
//            self.cancelRequest(button: button)
//        }
        self.cancelRequest(button: button)
    }
    func cancelRequest(button: UIButton) {
        let currentRequest = self.requests[button.tag]
        if let acceptedRequestId = currentRequest.acceptedRequest?.acceptedId {
            SVProgressHUD.show()
            ServerManager.sharedInstance.cancelRequest(requestId: acceptedRequestId) { (isSuccess, _) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    if let cell = self.requestsTableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? SozieRequestTableViewCell {
                        cell.timer?.invalidate()
                        cell.timer = nil
                    } else if let cell = self.requestsTableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? TargetRequestTableViewCell {
                        cell.timer?.invalidate()
                        cell.timer = nil
                    }
                    self.serverParams.removeAll()
                    self.requests.removeAll()
                    SVProgressHUD.show()
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.fetchUserDetail()
                    self.nextURL = nil
                    self.fetchRequestsFromServer()
                }
            }
        }
    }
    func nearByStorButtonAction(button: UIButton) {
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
        let popUpInstnc = StoresPopupVC.instance(productId: merchantId, productImage: imageURL, progreesVC: nil)
        popUpInstnc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
        _ = popUpVC.show(popUpInstnc)
        popUpInstnc.closeHandler = { [] in
            popUpVC.dismiss()
        }
    }
    func showAdidasStoresPopup(productId: String, imageURL: String, sku: String) {
        let popUpInstnc = StoresPopupListingVC.instance(productId: productId, productImage: imageURL, sku: sku, progreesVC: nil)
        popUpInstnc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
        _ = popUpVC.show(popUpInstnc)
        popUpInstnc.closeHandler = { [] in
            popUpVC.dismiss()
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
                    self.nearByStorButtonAction(button: button)
                }
            }
        }
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
            if let uploadPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostAndFitTipsVC") as? UploadPostAndFitTipsVC {
                uploadPostVC.currentRequest = currentRequest
                uploadPostVC.isFromProductDetail = true
                self.navigationController?.pushViewController(uploadPostVC, animated: true)
            }
        } else {
            UtilityManager.showMessageWith(title: "Are you sure you want to accept this request?", body: "You’ll have 19 days to upload your photos and complete your review.", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                UtilityManager.showMessageWith(title: "Are you a part of Sozie@Home?", body: "Only accept if you are part of our Sozie@Home program. In-store operations are paused until further notice.", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                    self.acceptRequestAPICall(tag: button.tag)
                }
            }
        }
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
        requestsViewModels.remove(at: tag)
        requestsViewModels.insert(viewModel, at: tag)
        self.requestsTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
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
        }
    }
    @objc func showInstructions() {
//        tutorialVC?.view.removeFromSuperview()
//        instructionsScrollView.isHidden = false
//        disableRootButtons()
    }
}

//extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return commentViewModels.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let viewModel = commentViewModels[indexPath.row]
//        var tableViewCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
//        if tableViewCell == nil {
//            tableView.register(UINib(nibName: viewModel.reuseIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.reuseIdentifier)
//            tableViewCell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseIdentifier)
//        }
//        guard let cell = tableViewCell else { return UITableViewCell() }
//        cell.selectionStyle = .none
//        if let cellConfigurable = cell as? CellConfigurable {
//            cellConfigurable.setup(viewModel)
//        }
//        return cell
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 62.0
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let allPosts = currentProduct?.posts {
//                let currentPost = allPosts[currentIndex - 1]
//                if let currentReview = currentPost.reviews?.reviews[indexPath.row] {
//                    if currentReview.addedBy.userId == UserDefaultManager.getCurrentUserId() {
//                        ServerManager.sharedInstance.deleteReview(reviewId: currentReview.reviewId) { (isSuccess, response) in
//                            if isSuccess {
//                                tableView.beginUpdates()
//                                tableView.deleteRows(at: [indexPath], with: .automatic)
//                                self.commentViewModels.remove(at: indexPath.row)
//                                tableView.endUpdates()
//                                self.fetchProductDetailFromServer()
//                            } else {
//                                UtilityManager.showErrorMessage(body: (response as! Error).localizedDescription, in: self)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if currentIndex != 0 {
//            if let allPosts = currentProduct?.posts {
//                let currentPost = allPosts[currentIndex - 1]
//                if let currentReview = currentPost.reviews?.reviews[indexPath.row] {
//                    if currentReview.addedBy.userId == UserDefaultManager.getCurrentUserId() {
//                        return true
//                    } else {
//                        return false
//                    }
//                }
//            }
//        }
//        return false
//    }
//}
