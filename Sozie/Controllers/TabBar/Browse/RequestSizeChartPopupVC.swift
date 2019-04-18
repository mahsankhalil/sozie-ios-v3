//
//  RequestSizeChartPopupVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol RequestSizeChartPopupVCDelegate: class {
    func selectedValueFromPopUp(value: String?)
}
class RequestSizeChartPopupVC: UIViewController {

    @IBOutlet weak var sendRequestButton: DZGradientButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModels: [SizeCellViewModel] = []
    var selectedIndex: Int?
    weak var delegate: RequestSizeChartPopupVCDelegate?
    var closeHandler: (() -> Void)?
    var currentProductId: String?
    var currentBrandId: Int?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var productSizeChart: [ProductSize]? {
        didSet {
            if let sizeChart = productSizeChart {
                viewModels.removeAll()
                for size in sizeChart {
                    let viewModel = SizeCellViewModel(isAvailable: size.inStock, isSelected: size.hasPosts, title: size.name, attributedTitle: nil)
                    viewModels.append(viewModel)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        borderView.applyStandardBorder()
        if self.delegate == nil {
            sendRequestButton.setTitle("Send Request", for: .normal)
        } else {
            sendRequestButton.setTitle("Select", for: .normal)
        }
    }
    static func instance(productSizeChart: [ProductSize]?, currentProductId: String? = nil, brandid: Int? = nil) -> RequestSizeChartPopupVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "RequestSizeChartPopupVC") as! RequestSizeChartPopupVC
        instnce.productSizeChart = productSizeChart
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
        instnce.currentProductId = currentProductId
        instnce.currentBrandId = brandid
        return instnce
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendRequestButtonTapped(_ sender: Any) {
        if let index = selectedIndex {
            if delegate != nil {
                delegate?.selectedValueFromPopUp(value: viewModels[index].title)
                closeHandler?()
                return
            }
        }
        makePostRequestToServer()
    }
    func makePostRequestToServer() {
        var dataDict = [String: Any]()
        if let index = selectedIndex {
            dataDict["size_worn"] = viewModels[index].title
        } else {
            UtilityManager.showErrorMessage(body: "Please select size.", in: self)
        }
        dataDict["product_id"] = currentProductId
        dataDict["brand"] = currentBrandId
        SVProgressHUD.show()
        ServerManager.sharedInstance.makePostRequest(params: dataDict) { (isSuccess, response) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.closeHandler?()
            } else {
                let error = response as! Error
                UtilityManager.showErrorMessage(body: error.localizedDescription, in: self)
            }
        }
    }
    func clearAllSelections() {
        for index in 0...viewModels.count-1 {
            viewModels[index].isSelected = false
        }
    }
}
extension RequestSizeChartPopupVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        popupController.popupView.layer.cornerRadius = 10.0
        popupController.popupView.clipsToBounds = true
        return CGSize(width: UIScreen.main.bounds.size.width - 35.0, height: 380)
    }
}
extension RequestSizeChartPopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel: RowViewModel
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath)
        rowViewModel = viewModels[indexPath.row]
        if let collectionCell = cell as? SizeCell {
         collectionCell.hideShowLinesInCell(indexPath: indexPath, count: viewModels.count)
        }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var availableWidth: Double
        availableWidth = Double(UIScreen.main.bounds.size.width - 26.0 - 35.0 - 20.0)

//        if collectionView == sizesCollectionVu {
//            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 )
//        } else {
//            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 - 34.0)
//
        let widthPerItem = Double(availableWidth/5.0)
        return CGSize(width: widthPerItem, height: 40.0 )
    }
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModels[indexPath.row].isAvailable {
            clearAllSelections()
            viewModels[indexPath.row].isSelected = true
            selectedIndex = indexPath.row
            collectionView.reloadData()
        }
    }
}
