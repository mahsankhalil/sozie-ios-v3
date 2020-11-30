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
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var checkStoresButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
//    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var productIdLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
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
        overlayView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pictureButtonTapped(_ sender: Any) {
        delegate?.pictureButtonTapped(button: sender as! UIButton)
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
        checkStoresButton.tag = index
        pictureButton.tag = index
    }
}
extension TargetRequestTableViewCell: CellConfigurable {
    func setup(_ viewModel: RowViewModel) {
        if let imgModel = viewModel as? ImageViewModeling {
            productImageView.sd_setImage(with: imgModel.imageURL) { (_, _, _, _) in
            }
        }
//        if let titleModel = viewModel as? TitleViewModeling {
//            titleLabel.text = titleModel.title!
//        }
        if let subTitleModel = viewModel as? SubtitleViewModeling {
            let attributedStr = NSMutableAttributedString(string: subTitleModel.subtitle!)
            attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 4))
            sizeRequestedLabel.attributedText = attributedStr
//            sizeRequestedLabel.text = subTitleModel.subtitle
        }
        if let colorTitleModel = viewModel as? ColorViewModeling {
            let attributedStr = NSMutableAttributedString(string: colorTitleModel.colorTitle!)
            attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location: 0, length: 5))
//            colorLabel.attributedText = attributedStr
//            colorLabel.text = colorTitleModel.colorTitle
        }
        if let availabilityModel = viewModel as? AvailabilityProviding {
            logoImageView.isHidden = !availabilityModel.isAvailable
            backgroudView.layer.borderColor = availabilityModel.isAvailable ? UIColor(hex: "FC8787").cgColor : UIColor(hex: "A6A6A6").cgColor
        } else {
            logoImageView.isHidden = true
            backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        }
        if let brandProvider = viewModel as? BrandIdProviding {
            if let brand = UserDefaultManager.getBrandWithId(brandId: brandProvider.brandId) {
                self.brandImageView.sd_setImage(with: URL(string: brand.titleImageCentred), completed: nil)
            }
        }
        if let productIdProvider = viewModel as? ProductIdProviding {
            let productId = productIdProvider.productId
            self.productIdLabel.text = "ID: " + productId
        }
        if let priceProvider = viewModel as? PriceProviding {
            self.priceLabel.text = priceProvider.price
        }
        logoImageView.isHidden = true
        backgroudView.layer.borderColor = UIColor(hex: "A6A6A6").cgColor
        self.handleAcceptRejectFunctionality(viewModel: viewModel)
    }
    func handleAcceptRejectFunctionality(viewModel: RowViewModel) {
        if let sozieRequestViewModel = viewModel as? SozieRequestCellViewModel {
            if sozieRequestViewModel.acceptedBySomeoneElse == true && sozieRequestViewModel.isSelected == true {
                self.overlayView.isHidden = false
                self.acceptButton.setTitle("ACCEPT REQUEST", for: .normal)
                self.acceptButton.backgroundColor = UtilityManager.getGenderColor()
                self.timerLabel.isHidden = true
                self.cancelButton.isHidden = true
            } else {
                self.overlayView.isHidden = true
                if let acceptedViewModel = viewModel as? SelectionProviding {
                    if acceptedViewModel.isSelected == true {
                        self.acceptButton.setTitle("UPLOAD PICTURE", for: .normal)
                        self.acceptButton.backgroundColor = UtilityManager.getGenderUploadPictureColor()
                        self.timerLabel.isHidden = false
                        self.cancelButton.isHidden = false
                    } else {
                        self.acceptButton.setTitle("ACCEPT REQUEST", for: .normal)
                        self.acceptButton.backgroundColor = UtilityManager.getGenderColor()
                        self.timerLabel.isHidden = true
                        self.cancelButton.isHidden = true
                    }
                }
            }
            if sozieRequestViewModel.acceptedBySomeoneElse == false {
                if let expiryViewModel = viewModel as? ExpiryViewModeling {
                    if !expiryViewModel.expiry.isEmpty {
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        dateFormat.timeZone = TimeZone(abbreviation: "UTC")
                        if let date = dateFormat.date(from: expiryViewModel.expiry) {
                            if timer == nil {
//                                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDownDate(timer:)), userInfo: ["date": date], repeats: true)
                                self.timerLabel.isHidden = false
                            } else {
                                timer?.invalidate()
                                timer = nil
                            }
                            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDownDate(timer:)), userInfo: ["date": date], repeats: true)
                            if let currentTimer = timer {
                                countDownDate(timer: currentTimer)
                            }
                        }
                    }
                }
            } else {
                self.timerLabel.isHidden = true
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
        if hours > 24 {
            let days = hours/24
            if days == 1 {
                timerLabel.text = String(format: "%d day left", days)
            } else {
                timerLabel.text = String(format: "%d days left", days)
            }
            return
        }
        let minutes = diffDateComponents.minute!
        let seconds = diffDateComponents.second!
        let countdown = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        timerLabel.text = countdown
    }
}
