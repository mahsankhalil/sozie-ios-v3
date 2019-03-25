//
//  BlockedUserCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol BlockedUserCellDelegate {
    func unblockButtonTapped(button: UIButton)
}
class BlockedUserCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    var delegate: BlockedUserCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unblockButton.layer.borderWidth = 1.0
        unblockButton.layer.borderColor = UIColor(hex: "7EA7E5").cgColor
        unblockButton.layer.cornerRadius = 3.0
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unblockButtonTapped(_ sender: Any) {
        delegate?.unblockButtonTapped(button: sender as! UIButton)
    }
}
extension BlockedUserCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let titleModel = viewModel as? TitleViewModeling {
            nameLabel.text = titleModel.title!
        }
        if let imgModel = viewModel as? ImageViewModeling {
            profileImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
    }
}
extension BlockedUserCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        unblockButton.tag = index
    }
}
