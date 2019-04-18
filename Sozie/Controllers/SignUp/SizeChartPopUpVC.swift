//
//  SizeChartPopUpVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/14/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol SizeChartPopupVCDelegate: class {
    func selectedValueFromPopUp(value: Int?, type: MeasurementType?, sizeType: SizeType?, sizeValue: String?)
}
public enum SizeType: String {
    case ukSize = "UK"
    case usSize = "US"
    case general = "GN"
}
class SizeChartPopUpVC: UIViewController {

    @IBOutlet weak var bottomVu: UIView!
    @IBOutlet weak var topVu: UIView!
    @IBOutlet weak var selectBtn: DZGradientButton!
    @IBOutlet weak var ukBtn: UIButton!
    @IBOutlet weak var usBtn: UIButton!
    @IBOutlet weak var sizesCollectionVu: UICollectionView!
    @IBOutlet weak var sizeChartCollectionVu: UICollectionView!

    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    var isUKSelected = false
    var sizeChartList: [SizeChart]? {
        didSet {
            if let sizeCharts = sizeChartList {
                ukViewModels.removeAll()
                usViewModels.removeAll()
                for sizeChart in sizeCharts {
                    let usViewModel = SizeCellViewModel(isAvailable: true, isSelected: false, title: sizeChart.usValue, attributedTitle: nil)
                    let ukViewModel = SizeCellViewModel(isAvailable: true, isSelected: false, title: sizeChart.ukValue, attributedTitle: nil)
                    ukViewModels.append(ukViewModel)
                    usViewModels.append(usViewModel)

                }
            }
        }
    }
    var generalList: [General]? {
        didSet {
            if let generals = generalList {
                generalViewModels.removeAll()
                for general in generals {
                    let viewModel = SizeCellViewModel(isAvailable: true, isSelected: false, title: general.label, attributedTitle: nil)
                    generalViewModels.append(viewModel)
                }
            }
        }
    }
    var generalViewModels: [SizeCellViewModel] = []
    var ukViewModels: [SizeCellViewModel] = []
    var usViewModels: [SizeCellViewModel] = []
    var isSelectedFromGeneral = false
    var generalSelectedIndex: Int?
    var usSelectedIndex: Int?
    var ukSelectedIndex: Int?
    weak var delegate: SizeChartPopupVCDelegate?
    var type: MeasurementType?
    var currentProductId: String?
    var currentBrandId: Int?
    var productSizeChart: [ProductSize]?
//    {
//        didSet {
//            if let sizeChart = productSizeChart {
//                generalViewModels.removeAll()
//                for general in sizeChart.generalSize {
//                    let viewModel = SizeCellViewModel(isSelected: general.hasPosts, title: general.name, attributedTitle: nil)
//                    generalViewModels.append(viewModel)
//                }
//                ukViewModels.removeAll()
//                for ukSize in sizeChart.ukSize {
//                    let viewModel = SizeCellViewModel(isSelected: ukSize.hasPosts, title: ukSize.name, attributedTitle: nil)
//                    ukViewModels.append(viewModel)
//                }
//                usViewModels.removeAll()
//                for usSize in sizeChart.usSize {
//                    let viewModel = SizeCellViewModel(isSelected: usSize.hasPosts, title: usSize.name, attributedTitle: nil)
//                    usViewModels.append(viewModel)
//                }
//            }
//        }
//    }

    var closeHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topVu.applyStandardBorder()
        bottomVu.applyStandardBorder()
    }

    // MARK: - Custom Methods

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func usBtnTapped(_ sender: Any) {
        isUKSelected = false
        usBtn.applyButtonSelectedWithoutBorder()
        ukBtn.applyButtonUnSelectedWithoutBorder()
        sizeChartCollectionVu.reloadData()

    }

    @IBAction func ukBtnTapped(_ sender: Any) {
        isUKSelected = true
        usBtn.applyButtonUnSelectedWithoutBorder()
        ukBtn.applyButtonSelectedWithoutBorder()
        sizeChartCollectionVu.reloadData()
    }

    @IBAction func selectBtnTapped(_ sender: Any) {
        if productSizeChart != nil {
            makeProductSizeChartSelection()
        } else {
            makeMeasurementSizeChartSelection()
        }
    }
    func makeMeasurementSizeChartSelection() {
        if isSelectedFromGeneral {
            let currentSelection = generalList![generalSelectedIndex!]
            switch type! {
            case .hips:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.hip.inch), type: .hips, sizeType: nil, sizeValue: nil)
            case .waist:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.waist.inch), type: .waist, sizeType: nil, sizeValue: nil)
            default:
                break
            }
        } else {
            guard let sizeChart = sizeChartList
                else {
                    closeHandler?()
                    return
            }
            var currentSelection: SizeChart
            if isUKSelected {
                currentSelection = sizeChart[ukSelectedIndex!]
            } else {
                currentSelection = sizeChart[usSelectedIndex!]
            }
            switch type! {
            case .hips:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.hip.inch), type: .hips, sizeType: nil, sizeValue: nil)
            case .waist:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.waist.inch), type: .waist, sizeType: nil, sizeValue: nil)
            default:
                break
            }
        }
        closeHandler?()
    }
    func makeProductSizeChartSelection() {
        if isSelectedFromGeneral {
            if let index = generalSelectedIndex {
                if delegate != nil {
                    delegate?.selectedValueFromPopUp(value: nil, type: nil, sizeType: SizeType.general, sizeValue: generalViewModels[index].title)
                    closeHandler?()
                    return
                }
            }
        } else if isUKSelected {
            if let index = ukSelectedIndex {
                if delegate != nil {
                    delegate?.selectedValueFromPopUp(value: nil, type: nil, sizeType: SizeType.ukSize, sizeValue: ukViewModels[index].title)
                    closeHandler?()
                    return
                }
            }
        } else {
            if let index = usSelectedIndex {
                if delegate != nil {
                    delegate?.selectedValueFromPopUp(value: nil, type: nil, sizeType: SizeType.usSize, sizeValue: usViewModels[index].title)
                    closeHandler?()
                    return
                }
            }
        }
        self.makePostRequestToServer()
    }

    func makePostRequestToServer() {
        var dataDict = [String: Any]()
        if isSelectedFromGeneral {
            dataDict["size_type"] = SizeType.general.rawValue
            if let index = generalSelectedIndex {
                dataDict["size_value"] = generalViewModels[index].title
            } else {
                UtilityManager.showErrorMessage(body: "Please select size.", in: self)
            }
        } else {
            if isUKSelected {
                dataDict["size_type"] = SizeType.ukSize.rawValue
                if let index = ukSelectedIndex {
                    dataDict["size_value"] = ukViewModels[index].title
                } else {
                    UtilityManager.showErrorMessage(body: "Please select size.", in: self)
                }
            } else {
                dataDict["size_type"] = SizeType.usSize.rawValue
                if let index = usSelectedIndex {
                    dataDict["size_value"] = usViewModels[index].title
                } else {
                    UtilityManager.showErrorMessage(body: "Please select size.", in: self)
                }
            }
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
        for index in 0...generalViewModels.count-1 {
            generalViewModels[index].isSelected = false
        }
        for index in 0...usViewModels.count-1 {
            usViewModels[index].isSelected = false
        }
        for index in 0...ukViewModels.count-1 {
            ukViewModels[index].isSelected = false
        }
    }

    static func instance(arrayOfSizeChart: [SizeChart]?, arrayOfGeneral: [General]?, type: MeasurementType?, productSizeChart: [ProductSize]?, currentProductId: String? = nil, brandid: Int? = nil) -> SizeChartPopUpVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "SizeChartPopUpVC") as! SizeChartPopUpVC
        instnce.sizeChartList = arrayOfSizeChart
        instnce.generalList = arrayOfGeneral
        instnce.productSizeChart = productSizeChart
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
        instnce.type = type
        instnce.currentProductId = currentProductId
        instnce.currentBrandId = brandid
        return instnce
    }
}

extension SizeChartPopUpVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        popupController.popupView.layer.cornerRadius = 10.0
        popupController.popupView.clipsToBounds = true
        return CGSize(width: UIScreen.main.bounds.size.width - 32.0, height: 500)
    }
}

extension SizeChartPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sizesCollectionVu {
            return generalViewModels.count
        } else {
            if isUKSelected {
                return ukViewModels.count
            } else {
                return usViewModels.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var rowViewModel: RowViewModel

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath)

        if collectionView == sizesCollectionVu {
            rowViewModel = generalViewModels[indexPath.row]
        } else {
            if isUKSelected {
                rowViewModel = ukViewModels[indexPath.row]
                if let collectionCell = cell as? SizeCell {
                    collectionCell.hideShowLinesInCell(indexPath: indexPath, count: ukViewModels.count)
                }
            } else {
                rowViewModel = usViewModels[indexPath.row]
                if let collectionCell = cell as? SizeCell {
                    collectionCell.hideShowLinesInCell(indexPath: indexPath, count: usViewModels.count)
                }
            }
        }
        if let cellConfigurable = cell as? CellConfigurable {
            cellConfigurable.setup(rowViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var availableWidth: Int
        if collectionView == sizesCollectionVu {
            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 )
        } else {
            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 - 34.0)
        }

        let widthPerItem = Double(availableWidth/5)
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
        clearAllSelections()
        if collectionView == sizesCollectionVu {
            isSelectedFromGeneral = true
            generalViewModels[indexPath.row].isSelected = true
            generalSelectedIndex = indexPath.row
        } else {
            if isUKSelected {
                ukViewModels[indexPath.row].isSelected = true
                ukSelectedIndex = indexPath.row
            } else {
                usViewModels[indexPath.row].isSelected = true
                usSelectedIndex = indexPath.row
            }
        }
//        if collectionView == sizesCollectionVu {
//            isSelectedFromGeneral = true
//            generalViewModels[indexPath.row].isSelected = true
//            if let previousSelectedIndex = generalSelectedIndex {
//                if previousSelectedIndex == indexPath.row {
//                    return
//                }
//                generalViewModels[previousSelectedIndex].isSelected = false
//                indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
//            }
//            generalSelectedIndex = indexPath.row
//
//        } else {
//            if isUKSelected {
//                ukViewModels[indexPath.row].isSelected = true
//                if let previousSelectedIndex = ukSelectedIndex {
//                    if previousSelectedIndex == indexPath.row {
//                        return
//                    }
//                    ukViewModels[previousSelectedIndex].isSelected = false
//                    indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
//                }
//                ukSelectedIndex = indexPath.row
//            } else {
//                usViewModels[indexPath.row].isSelected = true
//                if let previousSelectedIndex = usSelectedIndex {
//                    if previousSelectedIndex == indexPath.row {
//                        return
//                    }
//                    usViewModels[previousSelectedIndex].isSelected = false
//                    indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
//                }
//                usSelectedIndex = indexPath.row
//
//            }
//            isSelectedFromGeneral = false
//        }
//        collectionView.reloadItems(at: indexPathsToReload)
        sizesCollectionVu.reloadData()
        sizeChartCollectionVu.reloadData()
    }
}
