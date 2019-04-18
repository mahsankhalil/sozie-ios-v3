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
class ProductDetailVC: BaseViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var requestSozieButton: DZGradientButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buyButton: DZGradientButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeToSeeView: UIView!
    @IBOutlet weak var heartButtonWidthConstraint: NSLayoutConstraint!
    var currentProduct: Product?
    var viewModels: [PostCellViewModel] = []
    var productViewModel = ProductDetailCellViewModel()
    var currentPostId: Int?
    @IBOutlet weak var bottomView: UIView!
    var tipView: EasyTipView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        swipeToSeeView.roundCorners(corners: [.topLeft], radius: 20.0)
        setupSozieLogoNavBar()
//        populateProductData()
//        fetchProductDetailFromServer()
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(UINib(nibName: "ProductDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailCollectionViewCell")
        buyButton.layer.cornerRadius = 3.0
        requestSozieButton.layer.cornerRadius = 3.0
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        if UserDefaultManager.getIfShopper() {
            heartButtonWidthConstraint.constant = 32.0
            heartButton.isHidden = false
            buyButton.isHidden = false
            requestSozieButton.isHidden = false
        } else {
            heartButtonWidthConstraint.constant = 0.0
            heartButton.isHidden = true
            buyButton.isHidden = true
            requestSozieButton.isHidden = true
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken != nil {
            self.showTagItemButton()
            self.showCancelButton()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProductDetailFromServer()
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaultManager.getIfShopper() {
            if UserDefaultManager.getIfUserGuideShownFor(userGuide: UserDefaultKey.requestSozieButtonUserGuide) == false {
                showTipView()
            }
        }
    }
    func showTipView() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            let text = "After swiping, if you still don't see your size tried on, click above!"
            var prefer = UtilityManager.tipViewGlobalPreferences()
            prefer.drawing.arrowPosition = .top
            prefer.positioning.maxWidth = 110
            tipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
            tipView?.show(animated: true, forView: self.requestSozieButton, withinSuperview: self.bottomView)
            UserDefaultManager.setUserGuideShown(userGuide: UserDefaultKey.requestSozieButtonUserGuide)
            perform(#selector(self.dismissTipView), with: nil, afterDelay: 5.0)
        }
    }
    @objc func dismissTipView() {
        tipView?.dismiss(withCompletion: nil)
    }
    override func viewDidLayoutSubviews() {
//        descriptionTextLabel.setContentOffset(.zero, animated: false)
    }

    func fetchProductDetailFromServer () {
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
        makePostCellViewModel()
    }
    func assignImageURL() {
        if var imageURL = currentProduct?.merchantImageURL {
            if imageURL == "" {
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
        }
    }
    func makePostCellViewModel() {
        viewModels.removeAll()
        var indexOfPost = 0
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toUploadPost" {
            let uploadPostVC = segue.destination as! UploadPostVC
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
    }
    // MARK: - Actions

    @IBAction func requestSozieButtonTapped(_ sender: Any) {
        let popUpInstnc = RequestSizeChartPopupVC.instance(productSizeChart: currentProduct?.sizeChart, currentProductId: currentProduct?.productStringId, brandid: currentProduct?.brandId)
//        let popUpInstnc = SizeChartPopUpVC.instance(arrayOfSizeChart: nil, arrayOfGeneral: nil, type: nil, productSizeChart: currentProduct?.sizeChart, currentProductId: currentProduct?.productStringId, brandid: currentProduct?.brandId)
        let popUpVC = PopupController
            .create(self.tabBarController?.navigationController ?? self)
            .show(popUpInstnc)
//        popUpInstnc.delegate = self
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
            DispatchQueue.main.async {
                self.showSuccessPopUp()
            }
//            self.perform(#selector(self.showSuccessPopUp), with: nil, afterDelay: 1.0)
        }
    }
    @IBAction func butButtonTapped(_ sender: Any) {
//        if let productURL = self.currentProduct?.deepLink {
//            guard let url = URL(string: productURL) else { return }
//            let svc = SFSafariViewController(url: url)
//            svc.modalPresentationStyle = .pageSheet
//            self.tabBarController?.navigationController?.present(svc, animated: true, completion: nil)
////            self.present(svc, animated: true, completion: nil)
////            guard let url = URL(string: productURL) else { return }
////            UIApplication.shared.open(url)
//        }
//        self.performSegue(withIdentifier: "toWebVC", sender: self)
        if let productURL = self.currentProduct?.deepLink {

            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            webVC.url = URL(string: productURL)
            webVC.modalPresentationStyle = .overFullScreen
            self.tabBarController?.navigationController?.present(webVC, animated: true, completion: nil)
        }

    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        if var imageURL = currentProduct?.merchantImageURL {
            if imageURL == "" {
                if let imageURLTarget = currentProduct?.imageURL {
                    imageURL =  imageURLTarget
                }
            } else {
                if imageURL.contains("|") {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    imageURL = url[0]
                }
            }
            SVProgressHUD.show()
            SDWebImageDownloader.shared().downloadImage(with: URL(string: imageURL), options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (image, _, _, _) in
                SVProgressHUD.dismiss()
                if let downloadedImage = image {
                    if let productURL = self.currentProduct?.deepLink {
                        if let appLink = URL(string: "https://itunes.apple.com/us/app/sozie-shop2gether/id1363346896?ls=1&mt=8") {
                            UtilityManager.showActivityControllerWith(objectsToShare: [downloadedImage, productURL, appLink], viewController: self)
                        }

                    }
                }
            }
        }

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
        pageControl.currentPage = currentPage
        if let posts = currentProduct?.posts {
            if posts.count > 0 {
                swipeToSeeView.isHidden = currentPage > 0
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        if contentOffsetX > (scrollView.contentSize.width - scrollView.bounds.width)  /* Needed offset */ {            
            if UserDefaultManager.getIfShopper() == false {
                if (scrollView.contentSize.width - scrollView.bounds.width) != 0 {
                    UtilityManager.openImagePickerActionSheetFrom(viewController: self)
                }
            }
        }
    }
}
extension ProductDetailVC: PostCollectionViewCellDelegate {
    func profileButtonTapped(button: UIButton) {
        if let posts = self.currentProduct?.posts {
            let sozieProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "SozieProfileVC") as! SozieProfileVC
            let currentUser = posts[button.tag - 1].user
            currentPostId = posts[button.tag - 1].postId
            sozieProfileVC.user = currentUser
            self.navigationController?.pushViewController(sozieProfileVC, animated: true)
        }
    }

    func cameraButtonTapped(button: UIButton) {
        UtilityManager.openImagePickerActionSheetFrom(viewController: self)
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
        UtilityManager.openImagePickerActionSheetFrom(viewController: self)
    }
}
extension ProductDetailVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uploadPostVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPostVC") as? UploadPostVC {
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
