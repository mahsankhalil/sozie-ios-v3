//
//  SozieInstructionsHeaderTableViewCell.swift
//  Sozie
//
//  Created by Ahsan Khalil on 07/12/2020.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit

class SozieInstructionsHeaderTableViewCell: UITableViewHeaderFooterView {
    static let identifier = "SozieInstructionsHeaderTableViewCell"
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    public func configure(instructionStr: String, lineColor: UIColor) {
        instructionsLabel.text = instructionStr
        underLineView.backgroundColor = lineColor
    }
}
