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

public enum PopupType : String {
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
    @IBOutlet weak var brandsCollectionVu: UICollectionView!
    @IBOutlet weak var brandsVuHeightConstraint: NSLayoutConstraint!
    
    private var brandList: [Brand] = [] {
        didSet {
            brandViewModels.removeAll()
            for brand in brandList {
                let viewModel = ImageCellViewModel(imageURL: URL(string: brand.logo))
                brandViewModels.append(viewModel)
            }
            
        }
    }

    private var productList: [Product] = [] {
        didSet {
            for product in productList {
                let imageURL = product.imageURL.getActualSizeImageURL()
                let viewModel = ProductImageCellViewModel(title: String(product.searchPrice), attributedTitle: nil, titleImageURL: URL(string: product.brand.titleImage), imageURL:  URL(string: imageURL ?? ""))
                productViewModels.append(viewModel)
            }
            productsCollectionVu.reloadData()
        }
    }
    private var brandViewModels: [ImageCellViewModel] = []
    private var productViewModels : [ProductImageCellViewModel] = []
    var pageSize = 6
    var pagesPerRequest = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
        fetchBrandsFromServer()
        fetchProductsFromServer()
        setupViews()
        let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(fetchProductsFromServer), for: .valueChanged)
        productsCollectionVu.bottomRefreshControl = refreshControl
//        populateDummyData()
    }
    // MARK: - Custom Methods
    
    func setupViews() {
        searchTxtFld.delegate = self
        searchVuHeightConstraint.constant = 0.0
        let gstrRcgnzr = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        gstrRcgnzr.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gstrRcgnzr)
    }
    func showSearchVu() {
        searchVuHeightConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 47.0
            self.view.layoutIfNeeded()
            self.searchVu.applyShadowWith(radius: 8.0, shadowOffSet: CGSize(width: 0.0, height: 8.0), opacity: 0.5)
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func hideSearchVu() {
        searchVuHeightConstraint.constant = 47.0
        UIView.animate(withDuration: 0.3) {
            self.searchVuHeightConstraint.constant = 0.0
            self.searchVu.clipsToBounds = true
            self.dismissKeyboard()
            self.view.layoutIfNeeded()
        }
    }
//    func populateDummyData() {
//        for index in 0...16 {
//            if index % 2 == 0 {
//                productViewModels.append(ProductImageCellViewModel(title: "$10", attributedTitle: nil, titleImageURL: Bundle.main.url(forResource: "M_S", withExtension: "png"), imageURL:  Bundle.main.url(forResource: "ProductImg", withExtension: "png")))
//            } else {
//                productViewModels.append(ProductImageCellViewModel(title: "$10", attributedTitle: nil, titleImageURL: Bundle.main.url(forResource: "M_S", withExtension: "png"), imageURL:  Bundle.main.url(forResource: "ProductImg1", withExtension: "png")))
//            }
//
//        }
//        productsCollectionVu.reloadData()
//    }
    
    func fetchBrandsFromServer() {
        SVProgressHUD.show()
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.brandList = response as? [Brand] ?? []
                self.brandsCollectionVu.reloadData()
            }
        }
    }
    
    @objc func fetchProductsFromServer() {
        
        var dataDict = [String : Any]()
        dataDict["pagesize"] = pageSize
        dataDict["pages_per_request"] = pagesPerRequest
        
        ServerManager.sharedInstance.getAllProducts(params: dataDict) { (isSuccess, response) in
            self.productsCollectionVu.bottomRefreshControl?.endRefreshing()
            if isSuccess {
                self.productList = response as! [Product]
            } else {
                
            }
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
    
    func showPopUpWithTitle(type : PopupType) {
        let popUpInstnc : PopupNavController? = PopupNavController.instance(type: type , brandList: brandList)
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
    }
    
    
    // MARK: - Actions
    @IBAction func filterBtnTapped(_ sender: Any) {
        showPopUpWithTitle(type: .filter)
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
        if searchVuHeightConstraint.constant == 0 {
            showSearchVu()
        } else {
            hideSearchVu()
        }
    }
    @IBAction func categoryBtnTapped(_ sender: Any) {
        showPopUpWithTitle(type: .category)
    }
}
extension BrowseVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideSearchVu()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearchVu()
        return true
    }
}

extension BrowseVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandsCollectionVu {
            return brandViewModels.count
        } else {
            return productViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel : RowViewModel
        if collectionView == brandsCollectionVu {
            rowViewModel = brandViewModels[indexPath.row]

        } else
        {
            rowViewModel = productViewModels[indexPath.row]

        }
        var cell : UICollectionViewCell
        if let viewModel = rowViewModel as? ReuseIdentifierProviding {
           cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath)
        } else {
            return UICollectionViewCell()
        }

        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandsCollectionVu {
            return CGSize(width: 95.0  , height: 54.0 )
        } else {
            return CGSize(width: (UIScreen.main.bounds.size.width-44)/2  , height: 200.0 )
//            return CGSize(width: 0, height: 0)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
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
