//
//  TargetRequestTableViewCell.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 5/31/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

class TargetRequestTableViewCell: UITableViewCell {
    weak var delegate: SozieRequestTableViewCellDelegate?
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var sizeRequestedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var checkStoresButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroudView.layer.borderWidth = 0.5
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        backgroudView.applyShadowWith(radius: 4, shadowOffSet: CGSize(width: -4, height: 4), opacity: 0.1)
        productImageView.layer.borderWidth = 1.0
        productImageView.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        acceptButton.layer.cornerRadius = 3.0
        timerLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func acceptButtonTapped(_ sender: Any) {
        delegate?.acceptRequestButtonTapped(button: sender as! UIButton)
    }
    @IBAction func checkStoresButtonTapped(_ sender: Any) {
        delegate?.nearbyStoresButtonTapped(button: sender as! UIButton)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelRequestButtonTapped(button: sender as! UIButton)
    }
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
extension TargetRequestTableViewCell: ButtonProviding {
    func assignTagWith(_ index: Int) {
        acceptButton.tag = index
        cancelButton.tag = index
    }
}
extension TargetRequestTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
        if let titleModel = viewModel as? TitleViewModeling {
            titleLabel.text = titleModel.title!
        }
        if let subTitleModel = viewModel as? SubtitleViewModeling {
            sizeRequestedLabel.text = subTitleModel.subtitle
        }
        if let availabilityModel = viewModel as? AvailabilityProviding {
            logoImageView.isHidden = !availabilityModel.isAvailable
            backgroudView.layer.borderColor = availabilityModel.isAvailable ? UIColor(hex: "FC8787").cgColor : UIColor(hex: "A6A6A6").cgColor
            if availabilityModel.isAvailable == true {
                if let brandProvider = viewModel as? BrandIdProviding {
                    if let brand = UserDefaultManager.getBrandWithId(brandId: brandProvider.brandId) {
                        self.titleLabel.text = "Requested by " + brand.label
                    }
                }
            }
        } else {
            logoImageView.isHidden = true
            backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        }
        self.handleAcceptRejectFunctionality(viewModel: viewModel)
    }
    func handleAcceptRejectFunctionality(viewModel: RowViewModel) {
        if let acceptedViewModel = viewModel as? SelectionProviding {
            if acceptedViewModel.isSelected == true {
                self.acceptButton.setTitle("UPLOAD PICTURE", for: .normal)
                self.acceptButton.backgroundColor = UIColor(hex: "13AEF2")
                self.timerLabel.isHidden = false
                self.cancelButton.isHidden = false
            } else {
                self.acceptButton.setTitle("ACCEPT REQUEST", for: .normal)
                self.acceptButton.backgroundColor = UIColor(hex: "FC8787")
                self.timerLabel.isHidden = true
                self.cancelButton.isHidden = true
            }
        }
        if let expiryViewModel = viewModel as? ExpiryViewModeling {
            if !expiryViewModel.expiry.isEmpty {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormat.timeZone = TimeZone(abbreviation: "UTC")
                if let date = dateFormat.date(from: expiryViewModel.expiry) {
                    if timer == nil {
                        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDownDate(timer:)), userInfo: ["date": date], repeats: true)
                        self.timerLabel.isHidden = false
                    }
                }
            }
        }
    }
    @objc func countDownDate(timer: Timer) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        var futuredate: Date
        if let expiryDict = timer.userInfo as? [String: Date] {
            futuredate = expiryDict["date"]!
        } else {
            return
        }
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.hour, .minute, .second], from: Date(), to: futuredate)
        let hours = diffDateComponents.hour!
        let minutes = diffDateComponents.minute!
        let seconds = diffDateComponents.second!
        let countdown = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        timerLabel.text = countdown
    }
}
