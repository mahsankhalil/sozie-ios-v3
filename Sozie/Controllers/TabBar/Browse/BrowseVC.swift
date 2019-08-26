//
//  BrowseVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/25/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
import WaterfallLayout
import CCBottomRefreshControl
import EasyTipView

public enum PopupType: String {
    case category = "CATEGORY"
    case filter = "FILTER"
}
class BrowseVC: BaseViewController {

    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchVu: UIView!
    @IBOutlet weak var searchVuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var itemsCountLbl: UILabel!
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var productsCollectionVu: UICollectionView! {
        didSet {
            let layout = WaterfallLayout()
            layout.delegate = self
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumLineSpacing = 8.0
            layout.minimumInteritemSpacing = 8.0
            layout.headerHeight = 0.0
            productsCollectionVu.collectionViewLayout = layout
            productsCollectionVu.dataSource = self
        }
    }
    @IBOutlet weak var brandsCollectionVu: InfiniteScrollCollectionView!
    @IBOutlet weak var brandsVuHeightConstraint: NSLayoutConstraint!
    var categoryPopupInstance: PopupNavController?
    var filterPopupInstance: PopupNavController?
    var filterCategoryIds: [Float]?
    var filterBrandId: Int?
    var filterBySozies = false
    var selectedIndex: Int?
    var searchString: String?
    private var brandList: [Brand] = [] {
        didSet {
            brandViewModels.removeAll()
            for brand in brandList {
                let viewModel = ImageCellViewModel(imageURL: URL(string: brand.logo))
                brandViewModels.append(viewModel)
            }
            categoryPopupInstance = PopupNavController.instance(type: PopupType.category, brandList: UserDefaultManager.getALlBrands())
            filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
        }
    }

    private var productList: [Product] = [] {
        didSet {
            productViewModels.removeAll()
            for product in productList {
                let viewModel = ProductImageCellViewModel(product: product, identifier: "ProductCell")
                productViewModels.append(viewModel)
            }
            productsCollectionVu.reloadData()
            print(productsCollectionVu.contentOffset)
        }
    }
    private var brandViewModels: [ImageCellViewModel] = []
    private var productViewModels: [ProductImageCellViewModel] = []
    var pageSize = 6
    var pagesPerRequest = 3
    var isFirstPage = true
    var selectedProduct: Product?
    var currentSozieBrandId: Int?
    var cancelTipView: EasyTipView?
    var collectionTipView: EasyTipView?
    var gstrRcgnzr: UIGestureRecognizer?
    var tutorialVC: BrowseWelcomeVC?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.brandsCollectionVu.infiniteScrollDelegate = self
        _ = self.brandsCollectionVu.prepareDataSourceForInfiniteScroll(array: [])
        setupSozieLogoNavBar()
        
        
//        if let userType = UserDefaultManager.getCurrentUserType() {
//            if userType == UserType.shopper.rawValue {
//                setupSozieLogoNavBar()
//            } else {
//                brandsVuHeightConstraint.constant = 0.0
//                if let user = UserDefaultManager.getCurrentUserObject() {
//                    if let brandId = user.brand {
//                        if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
//                            setupBrandNavBar(imageURL: brand.titleImageCentred)
//                        }
//                        currentSozieBrandId = brandId
//                    }
//                }
//            }
//        }

        fetchBrandsFromServer()
//        fetchProductCount()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(rawValue: "RefreshBrowseData"), object: nil)
        self.refreshData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(#selector(showWelcomeView), with: nil, afterDelay: 0.5)
    }
    @objc func showWelcomeView() {
        if UserDefaultManager.getIfBrowseTutorialShown() == false {
            if tutorialVC == nil {
                tutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "BrowseWelcomeVC") as! BrowseWelcomeVC)
                tutorialVC?.delegate = self
                UIApplication.shared.keyWindow?.addSubview((tutorialVC?.view)!)
            }
        }
    }
    func showTipeViewAfterDelay() {
        perform(#selector(showTipView), with: nil, afterDelay: 0.5)
    }
    @objc func showTipView() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            let text = "To tag your photo, select model picture."
            var prefer = UtilityManager.tipViewGlobalPreferences()
            prefer.drawing.arrowPosition = .bottom
            prefer.positioning.maxWidth = 110
            collectionTipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
            collectionTipView?.show(animated: true, forView: self.productsCollectionVu, withinSuperview: self.view)
        }
    }
    override func showCancelButtonTipView() {
        if UserDefaultManager.isUserGuideDisabled() == false {
            let text = "You can cancel if you don't want to tag photo."
            var prefer = UtilityManager.tipViewGlobalPreferences()
            prefer.drawing.arrowPosition = .top
            prefer.positioning.maxWidth = 110
            prefer.positioning.bubbleVInset = 0
            cancelTipView = EasyTipView(text: text, preferences: prefer, delegate: nil)
            cancelTipView?.show(animated: true, forView: self.itemsCountLbl, withinSuperview: self.view)
            if let tipView = cancelTipView {
                tipView.frame = CGRect(x: tipView.frame.origin.x, y: tipView.frame.origin.y - 110.0, width: tipView.frame.width, height: tipView.frame.height)
            }
        }
    }
    override func cancelButtonTapped() {
        super.cancelButtonTapped()
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.imageTaken = nil
        cancelTipView?.dismiss()
        collectionTipView?.dismiss()

    }
    func updateCellModelIfChangeMadeInVisibleCells() {
        let visibleIndexPaths = productsCollectionVu.indexPathsForVisibleItems
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for index in 0..<productList.count where productList[index].productId == appDelegate.updatedProduct?.productId {
                productList[index].postCount = appDelegate.updatedProduct?.postCount
                productViewModels[index].count = productList[index].postCount ?? 0
        }
        productsCollectionVu.reloadItems(at: visibleIndexPaths)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCellModelIfChangeMadeInVisibleCells()
//        if UserDefaultManager.getIfShopper() == false {
//            if let user = UserDefaultManager.getCurrentUserObject() {
//                if let brandId = user.brand {
//                    if currentSozieBrandId != brandId {
//                        if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
//                            setupBrandNavBar(imageURL: brand.titleImageCentred)
//                        }
//                        currentSozieBrandId = brandId
//                        refreshData()
//                    }
//                }
//            }
//        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken == nil {
            super.cancelButtonTapped()
            cancelTipView?.dismiss()
            collectionTipView?.dismiss()
            if let index = selectedIndex {
                if index < productViewModels.count {
                    productViewModels[index].isSelected = false
                    productsCollectionVu.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
            }
        }
    }
    // MARK: - Custom Methods

    func setupViews() {
        searchTxtFld.delegate = self
        searchVuHeightConstraint.constant = 0.0
    }
    func showSearchVu() {
        searchVuHeightConstraint.constant = 0.0
        gstrRcgnzr = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gstrRcgnzr?.cancelsTouchesInView = true
        self.view.addGestureRecognizer(gstrRcgnzr!)
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchVu.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
            self.searchTxtFld.becomeFirstResponder()
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
        if let rcgnizer = gstrRcgnzr {
            self.view.removeGestureRecognizer(rcgnizer)
        }
    }
    func hideSearchVu() {
        if searchTxtFld.text?.isEmpty == false {
            searchString = searchTxtFld.text
            self.isFirstPage = true
            self.clearFilterButton.isHidden = false
            self.productList.removeAll()
            self.productsCollectionVu.refreshControl?.beginRefreshing()
            fetchProductsFromServerV3()
        } else {
            searchString = nil
        }
        searchVuHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 0.0
            self.searchVu.clipsToBounds = true
            self.dismissKeyboard()
            self.view.layoutIfNeeded()
        }
    }

    func fetchBrandsFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.brandList = response as! [Brand]
                _ = UserDefaultManager.saveAllBrands(brands: self.brandList)
                self.brandList = self.brandsCollectionVu.prepareDataSourceForInfiniteScroll(array: self.brandList) as! [Brand]
                self.brandsCollectionVu.reloadData()
                self.perform(#selector(self.setInitialOffsetToBrandsCollectionView), with: nil, afterDelay: 0.01)
//                if let user = UserDefaultManager.getCurrentUserObject() {
//                    if let brandId = user.brand {
//                        if let brand = UserDefaultManager.getBrandWithId(brandId: brandId) {
//                            self.setupBrandNavBar(imageURL: brand.titleImageCentred)
//                        }
//                    }
//                }
            }
        }
    }
    @objc func setInitialOffsetToBrandsCollectionView() {
        self.brandsCollectionVu.setInitialOffset()
    }
    @objc func loadNextPage() {
        isFirstPage = false
//        fetchProductsFromServer()
        fetchProductsFromServerV3()

    }
    @objc func refreshData() {
        searchTxtFld.text = ""
        isFirstPage = true
        filterBrandId = nil
        filterCategoryIds = nil
        filterBySozies = false
        clearFilterButton.isHidden = true
        searchString = nil
        productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
        productList.removeAll()
//        fetchProductCount()
//        fetchProductsFromServer()
        fetchProductsFromServerV3()

    }

    func fetchProductCount() {
        var dataDict = [String: Any]()
        dataDict["pagesize"] = pageSize
        dataDict["pages_per_request"] = pagesPerRequest
        if let brandId = filterBrandId {
            dataDict["brand"] = brandId
        }
        if let categoryIds = filterCategoryIds {
            dataDict["categories"] = categoryIds.makeArrayJSON()
        }
        if filterBySozies {
            dataDict["filter_by_sozie"] = filterBySozies
        }
//        if let userType = UserDefaultManager.getCurrentUserType() {
//            if userType == UserType.sozie.rawValue {
//                dataDict["brand"] = UserDefaultManager.getCurrentUserObject()?.brand
//            }
//        }
        ServerManager.sharedInstance.getProductsCount(params: dataDict) { (isSuccess, response) in
            if isSuccess {
                self.itemsCountLbl.text = String((response as! CountResponse).count) + ((response as! CountResponse).count <= 1 ? " ITEM" : " ITEMS")
            } else {

            }
        }
    }

    func fetchProductsFromServer() {
        var dataDict = [String: Any]()
        dataDict["pagesize"] = pageSize
        dataDict["pages_per_request"] = pagesPerRequest
        if isFirstPage {
            dataDict["is_first_page"] = isFirstPage
        }
        if let brandId = filterBrandId {
            dataDict["brand"] = brandId
        }
        if let categoryIds = filterCategoryIds {
            dataDict["categories"] = categoryIds.makeArrayJSON()
        }
        if filterBySozies {
            dataDict["filter_by_sozie"] = filterBySozies
        }
//        if let userType = UserDefaultManager.getCurrentUserType() {
//            if userType == UserType.sozie.rawValue {
//                dataDict["brand"] = UserDefaultManager.getCurrentUserObject()?.brand
//            }
//        }
        ServerManager.sharedInstance.getAllProducts(params: dataDict) { (isSuccess, response) in

            self.productsCollectionVu.refreshControl?.endRefreshing()
            self.productsCollectionVu.bottomRefreshControl?.endRefreshing()

            if isSuccess {
                self.productList.append(contentsOf: response as! [Product])
                self.productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 50
            } else {

            }
        }
    }
    func fetchProductsFromServerV3() {
        var dataDict = [String: Any]()
        dataDict["pagesize"] = pageSize
        dataDict["pages_per_request"] = pagesPerRequest
        if isFirstPage {
            dataDict["is_first_page"] = isFirstPage
        }
        if let brandId = filterBrandId {
            dataDict["brand"] = brandId
        }
        if let categoryIds = filterCategoryIds {
            dataDict["categories"] = categoryIds.makeArrayJSON()
        }
        if filterBySozies {
            dataDict["filter_by_sozie"] = filterBySozies
        }
        if let string = searchString {
            dataDict["query"] = string
        }
        ServerManager.sharedInstance.getALLProductV3(params: dataDict) { (isSuccess, response) in
            self.productsCollectionVu.refreshControl?.endRefreshing()
            self.productsCollectionVu.bottomRefreshControl?.endRefreshing()
            if isSuccess {
                self.itemsCountLbl.text = String((response as! BrowseResponse).count) + ((response as! BrowseResponse).count <= 1 ? " ITEM" : " ITEMS")
                self.productList.append(contentsOf: (response as! BrowseResponse).products)
                self.productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 50
            }
        }
    }

    func filterByBrand(brandId: Int?) {
        self.filterBrandId = brandId
    }
    func fetchFilteredData() {
        self.isFirstPage = true
        self.clearFilterButton.isHidden = false
        self.productsCollectionVu.refreshControl?.beginRefreshing()
//        fetchProductCount()
//        fetchProductsFromServer()
        fetchProductsFromServerV3()

    }
    func removeTargetIfUS(brands: [Brand]) -> [Brand] {
        var brandsList: [Brand] = []
        for brand in brands {
            if let user = UserDefaultManager.getCurrentUserObject() {
                if let countryId = user.country {
                    if countryId == 1 {
                        if brand.brandId == 10 {
                            continue
                        }
                    }
                }
            }
            brandsList.append(brand)
        }
        return brandsList
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as? ProductDetailVC
        destVC?.currentProduct = selectedProduct
    }

    func showPopUpWithTitle(type: PopupType) {
        var popUpInstnc: PopupNavController?
        if type == PopupType.category {
            popUpInstnc = categoryPopupInstance
        } else {
            popUpInstnc = filterPopupInstance
            if let brandId = filterBrandId {
                popUpInstnc?.selectedBrandId = brandId
            }
        }
        popUpInstnc?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        popUpInstnc?.popupDelegate = self
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
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

    // MARK: - Actions
    @IBAction func filterBtnTapped(_ sender: Any) {
        largeBottomView?.removeFromSuperview()
        showSmallBottomView()
        showPopUpWithTitle(type: .filter)
    }
    @IBAction func clearFilterButtonTapped(_ sender: Any) {
        categoryPopupInstance = PopupNavController.instance(type: PopupType.category, brandList: UserDefaultManager.getALlBrands())
        filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
        refreshData()
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
//        UtilityManager.showMessageWith(title: "This Feature is Coming Soon.", body: "", in: self)
        if searchVuHeightConstraint.constant == 0 {
            showSearchVu()
        } else {
            hideSearchVu()
        }
    }
    @IBAction func categoryBtnTapped(_ sender: Any) {
        largeBottomView?.removeFromSuperview()
        showSmallBottomView()
        showPopUpWithTitle(type: .category)
    }
    @objc override func nextButtonTapped() {
        performSegue(withIdentifier: "toProductDetail", sender: self)
    }
}
extension BrowseVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.imageTaken != nil {
            showSmallBottomView()
        }
        if scrollView == brandsCollectionVu {
            brandsCollectionVu.infiniteScrollViewDidScroll(scrollView: scrollView)
        }
    }
}
extension BrowseVC: InfiniteScrollCollectionViewDelegatge {
    func uniformItemSizeIn(collectionView: UICollectionView) -> CGSize {
        return CGSize(width: 95.0, height: 54.0 )
    }
}
extension BrowseVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideSearchVu()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchVu()
        return true
    }
}

extension BrowseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandsCollectionVu {
            return brandViewModels.count
        } else {
            return productViewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel: RowViewModel
        if collectionView == brandsCollectionVu {
            rowViewModel = brandViewModels[indexPath.row]
        } else {
            rowViewModel = productViewModels[indexPath.row]
        }
        var cell: UICollectionViewCell
        if let viewModel = rowViewModel as? ReuseIdentifierProviding {
           cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath)
        } else {
            return UICollectionViewCell()
        }
        if let cellIndexable = cell as? ButtonProviding {
            cellIndexable.assignTagWith(indexPath.row)
        }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandsCollectionVu {
            return CGSize(width: 95.0, height: 54.0 )
        } else {
            return CGSize(width: (UIScreen.main.bounds.size.width-44)/2, height: 200.0 )
        }

    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == brandsCollectionVu {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == brandsCollectionVu {
            return 0.0
        } else {
            return 16.0
        }
    }

    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (productList.count < 10 && indexPath.row == productList.count - 1) || (indexPath.row == productList.count - 10) {
            loadNextPage()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productsCollectionVu {
            selectedProduct = productList[indexPath.row]
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ProductCollectionViewCell {
                if let tipView = cell.tipView {
                    tipView.dismiss()
                }
            }
//            if appDelegate.imageTaken != nil {
//                productViewModels[indexPath.row].isSelected = true
//                var indexPathToReload = [indexPath]
//                if let index = selectedIndex {
//                    if index != indexPath.row {
//                        productViewModels[index].isSelected = false
//                        indexPathToReload.append(IndexPath(item: index, section: 0))
//                    }
//                }
//                self.productsCollectionVu.reloadItems(at: indexPathToReload)
//                self.showNextButton()
//                selectedIndex = indexPath.row
//                return
//            }
            largeBottomView?.removeFromSuperview()
            smallBottomView?.removeFromSuperview()
            performSegue(withIdentifier: "toProductDetail", sender: self)
        } else {
            let currentBrand = brandList[indexPath.row]
            filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
            productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
            productList.removeAll()
            filterByBrand(brandId: currentBrand.brandId)
            fetchFilteredData()

        }
    }
}
extension BrowseVC: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return WaterfallLayout.automaticSize
    }

    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }

}

extension BrowseVC: PopupNavControllerDelegate {
    func doneButtonTapped(type: FilterType?, objId: Int?) {
        productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
        productList.removeAll()
        if type == FilterType.filter {
            filterByBrand(brandId: objId)
        } else if type == FilterType.category {
            if let catId = objId {
                self.filterCategoryIds = [Float(catId)]
//                self.filterBrandId = nil
//                self.filterBySozies = false
            }
        } else if type == FilterType.sozie {
//            self.filterCategoryIds = nil
//            self.filterBrandId = nil
            self.filterBySozies = true
        }
        fetchFilteredData()
    }
}
extension BrowseVC: BrowseWelcomeDelegate {
    func profileButtonTapped() {
        self.tabBarController?.selectedIndex = 3
        tutorialVC?.view.removeFromSuperview()
    }
}
