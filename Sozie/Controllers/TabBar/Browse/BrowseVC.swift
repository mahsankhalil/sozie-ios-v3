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
import SideMenu
public enum PopupType: String {
    case category = "CATEGORY"
    case filter = "FILTER"
}
class BrowseVC: BaseViewController {

    @IBOutlet weak var searchOptionsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var searchByDescriptionButton: UIButton!
    @IBOutlet weak var searchByIdButton: UIButton!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchVu: UIView!
    @IBOutlet weak var searchVuHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var categoryCollectionVu: InfiniteScrollCollectionView!
    @IBOutlet weak var brandsVuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestedButton: UIButton!
    @IBOutlet weak var postsButton: UIButton!
    var categoryPopupInstance: PopupNavController?
    var filterPopupInstance: PopupNavController?
    var brandsFilterPopupInstance: SelectionPopupVC?
    var filterCategoryIds: [Int]?
    var filterBrandId: Int?
    var filterBySozies = false
    var selectedIndex: Int?
    var searchString: String?
    var totalCount: Int = 0
    var currentPage: Int = 1
    var filterType: String?
    private var categoriesList: [Category] = [] {
        didSet {
            categoriesViewModels.removeAll()
            for category in categoriesList {
                var activeCategoryImage = ""
                var inActiveCategoryImage = ""
                if let gender = UserDefaultManager.getCurrentUserGender() {
                    if gender == "M" {
                        activeCategoryImage = category.maleSelectedImage ?? ""
                        inActiveCategoryImage = category.maleNotSelectedImage ?? ""
                    } else {
                        activeCategoryImage = category.femaleSelectedImage ?? ""
                        inActiveCategoryImage = category.femaleNotSelectedImage ?? ""
                    }
                }
                let viewModel = ImageCellViewModel(imageURL: URL(string: inActiveCategoryImage), selectedImageURL: URL(string: activeCategoryImage), isSelected: false)
                categoriesViewModels.append(viewModel)
            }
            categoryPopupInstance = PopupNavController.instance(type: PopupType.category, brandList: UserDefaultManager.getALlBrands())
            filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
            brandsFilterPopupInstance = SelectionPopupVC.instance(type: .filter, brandList: UserDefaultManager.getALlBrands(), brandId: nil)
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
    private var categoriesViewModels: [ImageCellViewModel] = []
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
        self.categoryCollectionVu.infiniteScrollDelegate = self
        _ = self.categoryCollectionVu.prepareDataSourceForInfiniteScroll(array: [])
        setupSozieLogoNavBar()
        fetchBrandsFromServer()
        fetchCategoriesFromServer()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(rawValue: "RefreshBrowseData"), object: nil)
        resetButtonToDefault(button: self.requestedButton)
        resetButtonToDefault(button: self.postsButton)
        if let sozieType = UserDefaultManager.getCurrentSozieType(), sozieType == "BS" {
            filterBtn.isHidden = true
        } else {
            filterBtn.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(#selector(showWelcomeView), with: nil, afterDelay: 0.5)
    }
    func resetButtonToDefault(button: UIButton) {
        button.setTitleColor(UIColor(hex: "898989"), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hex: "0ABAB5").cgColor
        button.layer.cornerRadius = 3.0
    }
    func makeButtonSelected(button: UIButton) {
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(hex: "0ABAB5")
    }
    @objc func showWelcomeView() {
        if UserDefaultManager.getIfBrowseTutorialShown() == false {
            if tutorialVC == nil {
                tutorialVC = (self.storyboard?.instantiateViewController(withIdentifier: "BrowseWelcomeVC") as! BrowseWelcomeVC)
                tutorialVC?.delegate = self
                UIApplication.shared.keyWindow?.addSubview((tutorialVC?.view)!)
            }
        } else {
            if UserDefaultManager.getIfGoShoppingShown() == false {
                let goShoppingPopUp = self.storyboard?.instantiateViewController(withIdentifier: "GoShoppingVC")
                goShoppingPopUp?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                let popUpVC = PopupController
                    .create(self.tabBarController!.navigationController!)
                let options = PopupCustomOption.layout(.center)
                popUpVC.cornerRadius = 15.0
                _ = popUpVC.customize([options])
                _ = popUpVC.show(goShoppingPopUp!)
                UserDefaultManager.setGoShoppingShown()
            }
        }
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
    }
    // MARK: - Custom Methods

    func setupViews() {
        searchTxtFld.delegate = self
        searchVuHeightConstraint.constant = 0.0
        searchOptionsViewHeightConstraint.constant = 0.0
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
            searchTxtFld.text = ""
            self.isFirstPage = true
            currentPage = 1
            self.clearFilterButton.isHidden = false
            self.productList.removeAll()
            self.productsCollectionVu.refreshControl?.beginRefreshing()
            fetchProductsFromServer()
        }
        searchVuHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 0.0
            self.searchVu.clipsToBounds = true
            self.dismissKeyboard()
            self.view.layoutIfNeeded()
        }
    }

    func fetchCategoriesFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getAllCategories(params: [:]) { (isSuccess, response) in
            if isSuccess {
                self.categoriesList = response as! [Category]
                self.categoryCollectionVu.reloadData()
                self.refreshData()
            }
        }
    }

    func fetchBrandsFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let brandList = response as! [Brand]
                _ = UserDefaultManager.saveAllBrands(brands: brandList)
            }
        }
    }
    @objc func setInitialOffsetToBrandsCollectionView() {
        self.categoryCollectionVu.setInitialOffset()
    }
    @objc func loadNextPage() {
        isFirstPage = false
        if (currentPage < self.totalCount / 18) || (currentPage == self.totalCount / 18 && self.totalCount % 18 > 0) {
            currentPage = currentPage + 1
        }
        fetchProductsFromServer()
    }
    @objc func refreshData() {
        searchTxtFld.text = ""
        isFirstPage = true
        currentPage = 1
        filterBrandId = nil
        if let category = findCategoryWithId(categoryId: 10) {
            self.getAllSubCategoresIdFrom(category: category)
            if let clothigIndex = self.getIndexOfClothing() {
                categoriesViewModels[clothigIndex].isSelected = true
                self.categoryCollectionVu.reloadItems(at: [IndexPath(row: clothigIndex, section: 0)])
            }
        } else {
            filterCategoryIds = nil
        }
        filterBySozies = false
        clearFilterButton.isHidden = true
        searchString = nil
        filterType = nil
        productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
        productList.removeAll()
        fetchProductsFromServer()
        resetButtonToDefault(button: postsButton)
        resetButtonToDefault(button: requestedButton)
    }
    func findCategoryWithId(categoryId: Int) -> Category? {
        for category in categoriesList where category.categoryId == categoryId {
            return category
        }
        return nil
    }
    func getIndexOfClothing() -> Int? {
        for index in 0..<categoriesList.count {
            let category = categoriesList[index]
            if category.categoryId == 10 {
                return index
            }
        }
        return nil
    }
    func fetchProductsFromServer() {
        var dataDict = [String: Any]()
        dataDict["current_page"] = currentPage
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
        if let filter = filterType {
            dataDict["filter_type"] = filter
        }
        ServerManager.sharedInstance.getAllProducts(params: dataDict) { (isSuccess, response) in

            self.productsCollectionVu.refreshControl?.endRefreshing()
            self.productsCollectionVu.bottomRefreshControl?.endRefreshing()

            if isSuccess {
                self.totalCount = (response as! BrowseResponse).count
                self.itemsCountLbl.text = String((response as! BrowseResponse).count) + ((response as! BrowseResponse).count <= 1 ? " ITEM" : " ITEMS")
                self.productList.append(contentsOf: (response as! BrowseResponse).products)
                self.productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 50
            } else {

            }
        }
    }
    func filterByBrand(brandId: Int?) {
        self.filterBrandId = brandId
    }
    func fetchFilteredData() {
        self.isFirstPage = true
        currentPage = 1
        self.clearFilterButton.isHidden = false
        self.productsCollectionVu.refreshControl?.beginRefreshing()
        fetchProductsFromServer()
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
    func deSelectAllSelectedCategories() {
        for index in 0..<categoriesViewModels.count {
            categoriesViewModels[index].isSelected = false
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
    // MARK: - Actions
    @IBAction func requestedButtonTapped(_ sender: Any) {
        makeButtonSelected(button: sender as! UIButton)
        resetButtonToDefault(button: postsButton)
        filterType = "without_post"
        currentPage = 1
        productList.removeAll()
        filterCategoryIds = nil
        self.clearFilterButton.isHidden = false
        self.productsCollectionVu.refreshControl?.beginRefreshing()
        fetchProductsFromServer()
    }
    @IBAction func postsButtonTapped(_ sender: Any) {
        makeButtonSelected(button: sender as! UIButton)
        resetButtonToDefault(button: requestedButton)
        filterType = "with_post"
        currentPage = 1
        productList.removeAll()
        filterCategoryIds = nil
        self.clearFilterButton.isHidden = false
        self.productsCollectionVu.refreshControl?.beginRefreshing()
        fetchProductsFromServer()
    }
    @IBAction func filterBtnTapped(_ sender: Any) {
        hideSearchOptionView()
        hideSearchVu()
        brandsFilterPopupInstance?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        brandsFilterPopupInstance?.delegate = self
        let popUpVC = PopupController
            .create(self.tabBarController!.navigationController!)
        let options = PopupCustomOption.layout(.bottom)
        popUpVC.cornerRadius = 0.0
        _ = popUpVC.customize([options])
        _ = popUpVC.show(brandsFilterPopupInstance!)
        brandsFilterPopupInstance?.closeHandler = { [] in
            popUpVC.dismiss()
        }
    }
    @IBAction func clearFilterButtonTapped(_ sender: Any) {
        self.deSelectAllSelectedCategories()
        categoryCollectionVu.reloadData()
        categoryPopupInstance = PopupNavController.instance(type: PopupType.category, brandList: UserDefaultManager.getALlBrands())
        filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
        refreshData()
    }
    @IBAction func searchByDescriptionButtonTapped(_ sender: Any) {
        hideSearchOptionView()
        showSearchVu()
    }
    @IBAction func searchByIdButtonTapped(_ sender: Any) {
        hideSearchOptionView()
        showSearchVu()
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
//        UtilityManager.showMessageWith(title: "This Feature is Coming Soon.", body: "", in: self)
        if searchOptionsViewHeightConstraint.constant == 0 && searchVuHeightConstraint.constant == 0 {
            showSearchOptionView()
        } else if searchOptionsViewHeightConstraint.constant == 47.0 && searchVuHeightConstraint.constant == 0 {
            hideSearchOptionView()
        } else if searchVuHeightConstraint.constant == 47.0 && searchOptionsViewHeightConstraint.constant == 0.0 {
            hideSearchVu()
        }
//        if searchVuHeightConstraint.constant == 0 {
//            showSearchVu()
//        } else {
//            hideSearchVu()
//        }
    }
//    @IBAction func categoryBtnTapped(_ sender: Any) {
//        largeBottomView?.removeFromSuperview()
//        showSmallBottomView()
//        showPopUpWithTitle(type: .category)
//    }
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        var sideMenuSet = SideMenuSettings()
        sideMenuSet.presentationStyle.backgroundColor = UIColor.black
        sideMenuSet.presentationStyle = .menuSlideIn
        sideMenuSet.menuWidth = UIScreen.main.bounds.size.width - 60.0
        sideMenuSet.statusBarEndAlpha = 0.0
        sideMenuSet.blurEffectStyle = .light
        sideMenuSet.presentationStyle.menuStartAlpha = 0.0
        sideMenuSet.presentationStyle.presentingEndAlpha = 0.3
        let rightMenu = SideMenuNavigationController(rootViewController: (storyboard?.instantiateViewController(withIdentifier: "ProfileSideMenuVC"))!, settings: sideMenuSet)
        rightMenu.setNavigationBarHidden(true, animated: false)
        present(rightMenu, animated: true, completion: nil)

    }
}
extension BrowseVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideSearchOptionView()
        hideSearchVu()
        if scrollView == categoryCollectionVu {
            categoryCollectionVu.infiniteScrollViewDidScroll(scrollView: scrollView)
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
        if collectionView == categoryCollectionVu {
            return categoriesViewModels.count
        } else {
            return productViewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel: RowViewModel
        if collectionView == categoryCollectionVu {
            rowViewModel = categoriesViewModels[indexPath.row]
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
        if collectionView == categoryCollectionVu {
            return CGSize(width: 95.0, height: 54.0 )
        } else {
            return CGSize(width: (UIScreen.main.bounds.size.width-44)/2, height: 200.0 )
        }

    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollectionVu {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionVu {
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
        if productList.count < totalCount {
            if indexPath.row == productList.count - 6 {
                loadNextPage()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideSearchOptionView()
        hideSearchVu()
        if collectionView == productsCollectionVu {
            selectedProduct = productList[indexPath.row]
            performSegue(withIdentifier: "toProductDetail", sender: self)
        } else {
            self.getAllSubCategoresIdFrom(category: categoriesList[indexPath.row])
            filterPopupInstance = PopupNavController.instance(type: PopupType.filter, brandList: UserDefaultManager.getALlBrands())
            productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
            self.deSelectAllSelectedCategories()
            categoriesViewModels[indexPath.row].isSelected = true
            collectionView.reloadData()
            productList.removeAll()
            fetchFilteredData()
        }
    }
    func getAllSubCategoresIdFrom(category: Category) {
        filterCategoryIds?.removeAll()
        filterCategoryIds = [Int]()
        for subCategory in category.subCategories {
            filterCategoryIds?.append(subCategory.subCategoryId)
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

extension BrowseVC: PopupNavControllerDelegate, SelectionPopupVCDelegate {
    func doneButtonTapped(type: FilterType?, objId: Int?) {
        productsCollectionVu.bottomRefreshControl?.triggerVerticalOffset = 500
        productList.removeAll()
        if type == FilterType.filter {
            filterByBrand(brandId: objId)
        } else if type == FilterType.category {
            if let catId = objId {
                self.filterCategoryIds = [catId]
            }
        } else if type == FilterType.sozie {
            self.filterBySozies = true
        }
        fetchFilteredData()
    }
}
extension BrowseVC: BrowseWelcomeDelegate {
    func profileButtonTapped() {
        self.tabBarController?.selectedIndex = 2
        tutorialVC?.view.removeFromSuperview()
    }
}
