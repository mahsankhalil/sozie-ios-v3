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
class ProductDetailVC: BaseViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var requestSozieButton: DZGradientButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buyButton: DZGradientButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swipeToSeeView: UIView!
    var currentProduct: Product?
    var viewModels: [PostCellViewModel] = []
    var productViewModel = ProductDetailCellViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
//        populateProductData()
        fetchProductDetailFromServer()
        collectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostCollectionViewCell")
        collectionView.register(UINib(nibName: "ProductDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailCollectionViewCell")
        pageControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

    }
    override func viewDidLayoutSubviews() {
        descriptionTextView.setContentOffset(.zero, animated: false)
    }

    func fetchProductDetailFromServer () {
        if let productId = currentProduct?.productStringId {
            ServerManager.sharedInstance.getProductDetail(productId: productId) { (isSuccess, response) in
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
    }
    func populateProductData() {
        var priceString = ""
        var searchPrice = 0.0
        if let price = currentProduct?.searchPrice {
            searchPrice = Double(price)
        }
        if let currency = currentProduct?.currency?.getCurrencySymbol() {
            priceString = currency + " " + String(format: "%0.2f", searchPrice)
        }
        priceLabel.text = priceString
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {
            descriptionTextView.text = productName + "\n" +  productDescription
            descriptionTextView.setContentOffset(.zero, animated: true)
        }
        if let brandId = currentProduct?.brandId {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
                productViewModel.titleImageURL = URL(string: brand.titleImage)
            }
        }
        if let imageURL = currentProduct?.merchantImageURL {
            if let feedId = currentProduct?.feedId {
                if feedId == 18857 {
                    let delimeter = "|"
                    let url = imageURL.components(separatedBy: delimeter)
                    productViewModel.imageURL = URL(string: url[0])
                } else {
                    productViewModel.imageURL = URL(string: imageURL)
                }
            } else {
                productViewModel.imageURL = URL(string: imageURL)
            }
        }
        if currentProduct?.isFavourite == false {
            heartButton.setImage(UIImage(named: "Blank Heart"), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "Filled Heart"), for: .normal)
        }
        makePostCellViewModel()
        pageControl.currentPage = 0
        if let posts = currentProduct?.posts {
            if posts.count == 0 {
                swipeToSeeView.isHidden = true
            } else {
                swipeToSeeView.isHidden = false
            }
            pageControl.numberOfPages = posts.count + 1
        } else {
            pageControl.numberOfPages = 1
            swipeToSeeView.isHidden = true
        }
    }
    func makePostCellViewModel() {
        viewModels.removeAll()
        if let posts = currentProduct?.posts {
            var index = 0
            for post in posts {
                var viewModel = PostCellViewModel()
                viewModel.title = post.user.username
                viewModel.imageURL = URL(string: post.imageURL)
                viewModel.bra = post.user.measurement?.bra
                viewModel.height = post.user.measurement?.height
                viewModel.hip = post.user.measurement?.hip
                viewModel.cup = post.user.measurement?.cup
                viewModel.waist = post.user.measurement?.waist
                viewModel.index = index
                viewModel.isFollow = post.userFollowedByMe
                viewModels.append(viewModel)
                index = index + 1
            }
        }
        self.collectionView.reloadData()
    }

    func populateDummyData() {
        for _ in 0...4 {
            var viewModel = PostCellViewModel()
            viewModel.title = "test"
            viewModels.append(viewModel)
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

    // MARK: - Actions

    @IBAction func requestSozieButtonTapped(_ sender: Any) {
        let popUpInstnc = SizeChartPopUpVC.instance(arrayOfSizeChart: nil, arrayOfGeneral: nil, type: nil, productSizeChart: currentProduct?.sizeChart, currentProductId: currentProduct?.productStringId)
        let popUpVC = PopupController
            .create(self.tabBarController ?? self)
            .show(popUpInstnc)
//        popUpInstnc.delegate = self
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
    @IBAction func butButtonTapped(_ sender: Any) {
        if let productURL = self.currentProduct?.deepLink {
            guard let url = URL(string: productURL) else { return }
            UIApplication.shared.open(url)
        }

    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let imageURL = currentProduct?.merchantImageURL {
            SVProgressHUD.show()
            SDWebImageDownloader.shared().downloadImage(with: URL(string: imageURL), options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (image, _, _, _) in
                SVProgressHUD.dismiss()
                if let downloadedImage = image {
                    if let productURL = self.currentProduct?.deepLink {
                        if let appLink = URL(string: "https://itunes.apple.com/us/app/sozie-shop2gether/id1363346896?ls=1&mt=8") {
                            UtilityManager.showActivityControllerWith(objectsToShare: [downloadedImage, productURL, appLink], vc: self)
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
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(viewModel as! RowViewModel)
        }
        if let postCollectionCell = cell as? PostCollectionViewCell {
            postCollectionCell.delegate = self
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
        if currentPage > 0 {
            swipeToSeeView.isHidden = true
        } else {
            swipeToSeeView.isHidden = false
        }

    }
}
extension ProductDetailVC: PostCollectionViewCellDelegate {
    func moreButtonTapped(button: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { _ in
            if let posts = self.currentProduct?.posts {
                let postId = posts[button.tag].postId
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
                UtilityManager.showMessageWith(title: "Block " + posts[button.tag].user.username, body: "Are you sure you want to Block?", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", block: {
                    let userIdToBlock = posts[button.tag].user.userId
                    var dataDict = [String: Any]()
                    dataDict["blocker"] = UserDefaultManager.getCurrentUserId()
                    dataDict["user"] = userIdToBlock
                    SVProgressHUD.show()
                    ServerManager.sharedInstance.blockUser(params: dataDict, block: { (_, _ ) in
                        SVProgressHUD.dismiss()

                    })
                })

            }
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func followButtonTapped(button: UIButton) {
        var dataDict = [String: Any]()
        if let posts = currentProduct?.posts {
            let userId = posts[button.tag].user.userId
            dataDict["user"] = userId
            SVProgressHUD.show()
            ServerManager.sharedInstance.followUser(params: dataDict) { (isSuccess, _) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.currentProduct?.posts![button.tag].userFollowedByMe = true
                    self.viewModels[button.tag].isFollow = true
                    self.collectionView.reloadItems(at: [IndexPath(item: button.tag + 1, section: 0)])
                }
            }
        }
    }
}
