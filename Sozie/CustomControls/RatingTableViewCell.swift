//
//  RatingTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 7/1/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import Cosmos
protocol RatingTableViewCellDelegate: class {
    func ratingGiven(rating: Double, index: Int)
}
class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    weak var delegate: RatingTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rateView.settings.updateOnTouch = true
        rateView.settings.filledColor = UIColor(hex: "ffbe25")
        rateView.settings.emptyColor = UIColor(hex: "e0e0e0")
        rateView.settings.emptyBorderColor = UIColor.clear
        rateView.settings.filledBorderColor = UIColor.clear
        rateView.rating = 0.0
        rateView.settings.fillMode = .full
        rateView.didFinishTouchingCosmos = { (rating) in
            self.delegate?.ratingGiven(rating: rating, index: self.rateView.tag)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension RatingTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let rateViewModel = viewModel as? RatingQuestionsViewModel {
            if let title = rateViewModel.title {
                self.titleLabel.text = title
            }
            if let rating = rateViewModel.rating {
                self.rateView.rating = rating
            }
        }
    }
}
extension RatingTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        self.rateView.tag = index
    }
}
