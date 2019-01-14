//
//  SizeChartPopUpVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/14/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import PopupController
class SizeChartPopUpVC: UIViewController {

    @IBOutlet weak var bottomVu: UIView!
    @IBOutlet weak var topVu: UIView!
    @IBOutlet weak var selectBtn: DZGradientButton!
    @IBOutlet weak var ukBtn: UIButton!
    @IBOutlet weak var usBtn: UIButton!
    @IBOutlet weak var sizesCollectionVu: UICollectionView!
    @IBOutlet weak var sizeChartCollectionVu: UICollectionView!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topVu.applyStandardBorder()
        bottomVu.applyStandardBorder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func usBtnTapped(_ sender: Any) {
    }
    @IBAction func ukBtnTapped(_ sender: Any) {
    }
    @IBAction func selectBtnTapped(_ sender: Any) {
    }
    
    class func instance() -> SizeChartPopUpVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SizeChartPopUpVC") as! SizeChartPopUpVC
    }
    
}

extension SizeChartPopUpVC: PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 32.0 ,height: 500)
    }
}


extension SizeChartPopUpVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout
{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell
        
       
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
        
    }
    
    
    
}


