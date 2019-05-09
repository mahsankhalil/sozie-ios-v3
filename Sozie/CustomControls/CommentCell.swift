//
//  CommentCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/29/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
    }
}
extension CommentCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let titleViewModel = viewModel as? TitleViewModeling {
            if let title = titleViewModel.title {
                titleLabel.text = title
            } else if let attrTitle = titleViewModel.attributedTitle {
                titleLabel.attributedText = attrTitle
            }
        }
        if let imageViewModel = viewModel as? ImageViewModeling {
            profileImageView.sd_setImage(with: imageViewModel.imageURL, completed: nil)
        }
        if let descriptionViewModel = viewModel as? DescriptionViewModeling {
            let dateFormat = DateFormatter()
            if let desc = descriptionViewModel.description {
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormat.timeZone = TimeZone(abbreviation: "UTC")
                let date = dateFormat.date(from: desc)
                let timeAgo = UtilityManager.timeAgoSinceDate(date: date! as NSDate, numericDates: true)
                timeLabel.text = timeAgo
            }
        }
    }
}
