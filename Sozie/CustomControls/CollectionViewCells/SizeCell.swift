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

    func hideShowLinesInCell(indexPath: IndexPath, count: Int) {
        if indexPath.row % 5 == 4 {
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
extension SizeCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let titleViewodel = viewModel as? TitleViewModeling {
            if let title = titleViewodel.title {
                self.titleLbl.text = title
            } else if let attributedTitle = titleViewodel.attributedTitle {
                self.titleLbl.attributedText = attributedTitle
            }
        }
        if let selectionViewModel = viewModel as? SelectionProviding {
            if selectionViewModel.isSelected {
                self.titleLbl.textColor = UIColor(hex: "FC8888")
            } else {
                if let availabilityViewModel = viewModel as? AvailabilityProviding {
                    if availabilityViewModel.isAvailable {
                        self.titleLbl.textColor = UIColor(hex: "323232")
                    } else {
                        self.titleLbl.textColor = UIColor(hex: "888888")
                    }
                }
            }
        }
    }
}
