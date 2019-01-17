//
//  SizeChartPopUpVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/14/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

protocol SizeChartPopupVCDelegate {
    func selectedValueFromPopUp(value : Int , type : MeasurementType)
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

    var sizeChartList : [SizeChart]?
    var generalList : [General]?
    
    var isSelectedFromGeneral = false
    var selectedIndex : Int?
    var delegate : SizeChartPopupVCDelegate?
    var type : MeasurementType?
    
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
        if isSelectedFromGeneral
        {
            let currentSelection = generalList![selectedIndex!]
            switch type! {
            case .hips:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.hip.inch), type: .hips)
            case .waist:
                delegate?.selectedValueFromPopUp(value: Int(currentSelection.waist.inch), type: .waist)

             default:
                break
            }
        }
        else
        {
            let currentSelection = sizeChartList![selectedIndex!]
           
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
    
    class func instance(arrayOfSizeChart : [SizeChart] , arrayOfGeneral : [General] , type : MeasurementType) -> SizeChartPopUpVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let instnce = storyboard.instantiateViewController(withIdentifier: "SizeChartPopUpVC") as! SizeChartPopUpVC
        instnce.sizeChartList = arrayOfSizeChart
        instnce.generalList = arrayOfGeneral
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
        return CGSize(width: UIScreen.main.bounds.size.width - 32.0 ,height: 500)
    }
}


extension SizeChartPopUpVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sizesCollectionVu
        {
            return generalList?.count ?? 0
        }
        else
        {
            return sizeChartList?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell

        if collectionView == sizesCollectionVu
        {
            let currentGeneralSize = generalList?[indexPath.row]
            cell.titleLbl.text = currentGeneralSize?.label
        }
        else
        {
            let currentSizeChart = sizeChartList?[indexPath.row]
            if isUKSelected
            {
                cell.titleLbl.text = String(describing: currentSizeChart!.uk)

            }
            else
            {
                cell.titleLbl.text = String(describing: currentSizeChart!.us)

            }
            
            cell.hideShowLinesInCell(indexPath: indexPath, count: sizeChartList!.count)
        }
        
        self.configureCellSelection(indexPath: indexPath, collectionView: collectionView, cell: cell)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
//        let paddingSpace = Int(sectionInsets.left)
        
        var availableWidth : Int
        if collectionView == sizesCollectionVu
        {
            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 )
        }
        else
        {
            availableWidth = Int(UIScreen.main.bounds.size.width - 28.0 - 32.0 - 34.0)
        }
        let widthPerItem = Double(availableWidth/5)
        
        return CGSize(width: widthPerItem  , height: 40.0 )
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizesCollectionVu
        {
            isSelectedFromGeneral = true
            
        }
        else
        {
            isSelectedFromGeneral = false

        }
        selectedIndex = indexPath.row
        sizesCollectionVu.reloadData()
        sizeChartCollectionVu.reloadData()
    }
    
    func configureCellSelection(indexPath : IndexPath , collectionView : UICollectionView , cell : SizeCell)
    {
        if isSelectedFromGeneral
        {
            if collectionView == sizesCollectionVu
            {
                if selectedIndex == indexPath.row
                {
                    cell.titleLbl.textColor = UIColor(hex: "FC8888")
                }
                else
                {
                    cell.titleLbl.textColor = UIColor.black
                    
                }
            }
            else
            {
                cell.titleLbl.textColor = UIColor.black
            }
        }
        else
        {
            if collectionView == sizesCollectionVu
            {
                cell.titleLbl.textColor = UIColor.black
            }
            else
            {
                if selectedIndex == indexPath.row
                {
                    cell.titleLbl.textColor = UIColor(hex: "FC8888")
                }
                else
                {
                    cell.titleLbl.textColor = UIColor.black
                    
                }
                
            }
        }
    }
    
}


