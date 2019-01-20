//
//  SizeCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/14/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sideLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    func hideShowLinesInCell(indexPath : IndexPath , count : Int) {
        if (indexPath.row % 5 == 4) {
            sideLine.isHidden = true
        } else {
            sideLine.isHidden = false
        }
        
        let rem = count % 5
        if rem == 0 {
            if indexPath.row >= count - 5 {
                bottomLine.isHidden = true
            } else {
                bottomLine.isHidden = false
            }
        } else {
            let div = count / 5
            if indexPath.row >= div * 5 {
                bottomLine.isHidden = true
            } else {
                bottomLine.isHidden = false
            }
        }
    }
}
