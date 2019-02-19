//
//  ProductDetailVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

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
        if let productId = currentProduct?.productId {
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
    }
    func populateProductData() {
        if let price = currentProduct?.searchPrice {
            priceLabel.text = String(price)
        }
        if let productName = currentProduct?.productName, let productDescription = currentProduct?.description {

            descriptionTextView.text = productName + "\n" +  productDescription
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
            for post in posts {
                var viewModel = PostCellViewModel()
                viewModel.title = post.user.username
                viewModel.imageURL = URL(string: post.imageURL)
                viewModel.bra = post.user.measurement?.bra
                viewModel.height = post.user.measurement?.height
                viewModel.hip = post.user.measurement?.hip
                viewModel.cup = post.user.measurement?.cup
                viewModel.waist = post.user.measurement?.waist
                viewModels.append(viewModel)
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
    }
    @IBAction func butButtonTapped(_ sender: Any) {
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    @IBAction func heartButtonTapped(_ sender: Any) {
        if currentProduct?.isFavourite == false {
            if let productId = currentProduct?.productId {
                self.heartButton.setImage(UIImage(named: "Filled Heart"), for: .normal)
                var dataDict = [String: Any]()
                dataDict["user"] = UserDefaultManager.getCurrentUserId()
                dataDict["product"] = productId
                ServerManager.sharedInstance.favouriteProduct(params: dataDict) { (isSuccess, _) in

                    if isSuccess {
                        self.currentProduct?.isFavourite = true
                    }
                }
            }
        } else {
            if let productId = currentProduct?.productId {
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
