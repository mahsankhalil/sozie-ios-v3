//
//  TitleAndSwitchCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 1/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol TitleAndSwitchCellDelegate: class {
    func switchValueChanged(switchButton: UISwitch)
}
class TitleAndSwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var bottomLine: UIView!
    weak var delegate: TitleAndSwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchControl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchValueChanged(switchButton: sender as! UISwitch)
    }
}

extension TitleAndSwitchCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        // Check for TitleViewModeling
        if let titleModel = viewModel as? TitleViewModeling {
            if let title = titleModel.title {
                titleLabel.text = title
                if title == "Reset Tutorial" {
                    if let user = UserDefaultManager.getCurrentUserObject() {
                        if user.tutorialCompleted == true && user.isTutorialApproved == nil {
                            switchControl.isUserInteractionEnabled = false
                        } else if user.isTutorialApproved == true {
                            switchControl.isUserInteractionEnabled = false
                        } else if user.isTutorialApproved == false {
                            switchControl.isUserInteractionEnabled = true
                        } else {
                            switchControl.isUserInteractionEnabled = true
                        }
                    }
                }
            }
            if let attributedTitle = titleModel.attributedTitle {
                titleLabel.attributedText = attributedTitle
            }
        }
        if let switchModel = viewModel as? SwitchProviding {
            switchControl.setOn(switchModel.isSwitchOn ?? false, animated: true)
        }
        if let lineModel = viewModel as? LineProviding {
            bottomLine.isHidden = lineModel.isHidden
        }
    }
}

extension TitleAndSwitchCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        switchControl.tag = index
    }
}
