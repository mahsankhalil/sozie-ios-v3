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

struct BrandImageCellViewModel: RowViewModel, ImageViewModeling , ReuseIdentifierProviding {
    var imgURL: URL?
    let reuseIdentifier = "ImageViewCell"
}

struct ProductImageCellViewModel : RowViewModel , TitleViewModeling , ImageViewModeling , TitleImgViewModeling , ReuseIdentifierProviding {
    var title: String?
    var attributedTitle: NSAttributedString?
    var titleImgURL: URL?
    var imgURL: URL?
    let reuseIdentifier = "ProductCell"

}
class BrowseVC: BaseViewController {

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
            viewModels.removeAll()
            for brand in brandList {
                let viewModel = BrandImageCellViewModel(imgURL: URL(string: brand.logo))
                viewModels.append(viewModel)
            }
            
        }
    }

    private var viewModels: [BrandImageCellViewModel] = []
    private var productViewModels : [ProductImageCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSozieLogoNavBar()
        fetchBrandsFromServer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateDummyData()
    }
    // MARK: - Custom Methods
    
    func populateDummyData() {
        for index in 0...16 {
            if index % 2 == 0 {
                productViewModels.append(ProductImageCellViewModel(title: "$10", attributedTitle: nil, titleImgURL: Bundle.main.url(forResource: "M_S", withExtension: "png"), imgURL:  Bundle.main.url(forResource: "ProductImg", withExtension: "png")))
            } else {
                productViewModels.append(ProductImageCellViewModel(title: "$10", attributedTitle: nil, titleImgURL: Bundle.main.url(forResource: "M_S", withExtension: "png"), imgURL:  Bundle.main.url(forResource: "ProductImg1", withExtension: "png")))
            }
            
        }
        productsCollectionVu.reloadData()
    }
    
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
    
    func fetchProductsFromServer() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func filterBtnTapped(_ sender: Any) {
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
    }
    @IBAction func categoryBtnTapped(_ sender: Any) {
    }
}
extension BrowseVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandsCollectionVu {
            return viewModels.count
        } else {
            return productViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel : RowViewModel
        if collectionView == brandsCollectionVu {
            rowViewModel = viewModels[indexPath.row]

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
        if collectionView == brandsCollectionVu {
            return 12.0
        } else {
            return 12.0
        }
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
