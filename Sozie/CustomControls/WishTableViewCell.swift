//
//  WishTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/18/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol WishTableViewCellDelegate: class {
    func crossButonTapped(btn: UIButton)
    func viewRequestsButtonTapped(button: UIButton)
}
class WishTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var viewRequestsButton: DZGradientButton!
    weak var delegate: WishTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroudView.layer.borderWidth = 1.0
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        backgroudView.applyShadowWith(radius: 4, shadowOffSet: CGSize(width: -4, height: 4), opacity: 0.1)
        productImageView.layer.borderWidth = 1.0
        productImageView.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        delegate?.crossButonTapped(btn: sender as! UIButton)
    }
    @IBAction func viewRequestsButtonTapped(_ sender: Any) {
        delegate?.viewRequestsButtonTapped(button: sender as! UIButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension WishTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
        if let titleImgModel = viewModel as? TitleImageViewModeling {
            titleImageView.sd_setImage(with: titleImgModel.titleImageURL, completed: nil)
        }
        if let descriptionModel = viewModel as? DescriptionViewModeling {
            if let description = descriptionModel.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = ""
            }
        }
    }
}
extension WishTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        viewRequestsButton.tag = index
        crossButton.tag = index
    }
}
