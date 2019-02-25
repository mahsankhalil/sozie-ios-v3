//
//  SizeChartPopUpVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/14/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value: Int, type: MeasurementType)
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
                    let usViewModel = SizeCellViewModel(isSelected: false, title: sizeChart.us, attributedTitle: nil)
                    let ukViewModel = SizeCellViewModel(isSelected: false, title: sizeChart.uk, attributedTitle: nil)
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
                    let viewModel = SizeCellViewModel(isSelected: false, title: general.label, attributedTitle: nil)
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
    var delegate: SizeChartPopupVCDelegate?
    var type: MeasurementType?
    var productSizeChart: ProductSizeChart? {
        didSet {
            if let sizeChart = productSizeChart {
                generalViewModels.removeAll()
                for general in sizeChart.generalSize {
                    let viewModel = SizeCellViewModel(isSelected: general.hasPosts, title: general.name, attributedTitle: nil)
                    generalViewModels.append(viewModel)
                }
                ukViewModels.removeAll()
                for ukSize in sizeChart.ukSize {
                    let viewModel = SizeCellViewModel(isSelected: ukSize.hasPosts, title: ukSize.name, attributedTitle: nil)
                    ukViewModels.append(viewModel)
                }
                usViewModels.removeAll()
                for usSize in sizeChart.ukSize {
                    let viewModel = SizeCellViewModel(isSelected: usSize.hasPosts, title: usSize.name, attributedTitle: nil)
                    usViewModels.append(viewModel)
                }
            }
        }
    }

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
        if isSelectedFromGeneral {
            let currentSelection = generalList![generalSelectedIndex!]
            switch type! {
            case .hips:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.hip.inch), type: .hips)
            case .waist:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.waist.inch), type: .waist)

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
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.hip.inch), type: .hips)
            case .waist:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.waist.inch), type: .waist)
            default:
                break
            }
        }

        closeHandler?()
    }

    static func instance(arrayOfSizeChart: [SizeChart]?, arrayOfGeneral: [General]?, type: MeasurementType?, productSizeChart: ProductSizeChart?) -> SizeChartPopUpVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "SizeChartPopUpVC") as! SizeChartPopUpVC
        instnce.sizeChartList = arrayOfSizeChart
        instnce.generalList = arrayOfGeneral
        instnce.productSizeChart = productSizeChart
        instnce.view.layer.cornerRadius = 10.0
        instnce.view.clipsToBounds = true
        instnce.type = type
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
        var indexPathsToReload = [indexPath]
        if collectionView == sizesCollectionVu {
            isSelectedFromGeneral = true
            generalViewModels[indexPath.row].isSelected = true
            if let previousSelectedIndex = generalSelectedIndex {
                if previousSelectedIndex == indexPath.row {
                    return
                }
                generalViewModels[previousSelectedIndex].isSelected = false
                indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
            }
            generalSelectedIndex = indexPath.row

        } else {
            if isUKSelected {
                ukViewModels[indexPath.row].isSelected = true
                if let previousSelectedIndex = ukSelectedIndex {
                    if previousSelectedIndex == indexPath.row {
                        return
                    }
                    ukViewModels[previousSelectedIndex].isSelected = false
                    indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
                }
                ukSelectedIndex = indexPath.row
            } else {
                usViewModels[indexPath.row].isSelected = true
                if let previousSelectedIndex = usSelectedIndex {
                    if previousSelectedIndex == indexPath.row {
                        return
                    }
                    usViewModels[previousSelectedIndex].isSelected = false
                    indexPathsToReload.append(IndexPath(row: previousSelectedIndex, section: 0))
                }
                usSelectedIndex = indexPath.row

            }
            isSelectedFromGeneral = false
        }
        collectionView.reloadItems(at: indexPathsToReload)

    }
}
