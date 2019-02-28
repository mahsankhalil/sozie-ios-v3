//
//  SozieRequestTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/28/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol SozieRequestTableViewCellDelegate {
    func acceptRequestButtonTapped(button: UIButton)
}
class SozieRequestTableViewCell: UITableViewCell {
    var delegate: SozieRequestTableViewCellDelegate?
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var sizeRequestedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var hipLabel: UILabel!
    @IBOutlet weak var braLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroudView.layer.borderWidth = 0.5
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        backgroudView.applyShadowWith(radius: 4, shadowOffSet: CGSize(width: -4, height: 4), opacity: 0.1)
        productImageView.layer.borderWidth = 1.0
        productImageView.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        acceptButton.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate?.acceptRequestButtonTapped(button: sender as! UIButton)
    }
    
}
extension SozieRequestTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
        
        if let titleModel = viewModel as? TitleViewModeling {
            titleLabel.text = titleModel.title!
        }
        if let selectionModel = viewModel as? SelectionProviding {
            
        }
        if let subTitleModel = viewModel as? SubtitleViewModeling {
            sizeRequestedLabel.text = subTitleModel.subtitle
        }
        if let descriptionModel = viewModel as? DescriptionViewModeling {
            descriptionLabel.text = descriptionModel.description
        }
    }
}
extension SozieRequestTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        acceptButton.tag = index
    }
}
