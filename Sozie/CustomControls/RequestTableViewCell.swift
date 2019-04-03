//
//  RequestTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 2/21/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
protocol RequestTableViewCellDelegate: class {
    func buyButtonTapped(button: UIButton)
}
class RequestTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var sizeRequestedLabel: UILabel!
    @IBOutlet weak var sozieReadyLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var buyButton: DZGradientButton!
    weak var delegate: RequestTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroudView.layer.borderWidth = 0.5
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        backgroudView.applyShadowWith(radius: 4, shadowOffSet: CGSize(width: -4, height: 4), opacity: 0.1)
        productImageView.layer.borderWidth = 1.0
        productImageView.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        makeAttributedLabel()
    }
    func makeAttributedLabel() {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named: "checkedSmall")
        //Set bound to reposition
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "Your Sozie picture is ready ")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        self.sozieReadyLabel.textAlignment = .left
        self.sozieReadyLabel.attributedText = completeText
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buyButtonTapped(_ sender: Any) {
        delegate?.buyButtonTapped(button: sender as! UIButton)
    }
}
extension RequestTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
        if let titleImgModel = viewModel as? TitleImageViewModeling {
            titleImageView.sd_setImage(with: titleImgModel.titleImageURL, completed: nil)
        }
        if let titleModel = viewModel as? TitleViewModeling {
            productTitleLabel.text = titleModel.title!
        }
        if let selectionModel = viewModel as? SelectionProviding {
            if selectionModel.isSelected {
                sozieReadyLabel.isHidden = false
            } else {
                sozieReadyLabel.isHidden = true
            }
        }
        if let subTitleModel = viewModel as? SubtitleViewModeling {
            sizeRequestedLabel.text = subTitleModel.subtitle
        }
        if let priceModel = viewModel as? PriceProviding {
            priceLabel.text = priceModel.price
        }
    }
}
extension RequestTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        buyButton.tag = index
    }
}
