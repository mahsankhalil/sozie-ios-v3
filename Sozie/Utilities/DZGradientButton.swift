//
//  DZGradientButton.swift
//  Sozie
//
//  Created by Danial Zahid on 18/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import Hex

@IBDesignable class DZGradientButton: UIButton {

    var shadowAdded: Bool = false
    var cornerRadius: CGFloat?
    var shadowLayer: UIView?
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                gradientStartColor = UIColor(hex: "17B5F9")
                gradientEndColor = UIColor(hex: "48C8FF")
            }
        } else {
            gradientStartColor = UIColor(hex: "0ABAB5")
            gradientEndColor = UIColor(hex: "2EDCD7")
        }
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.opacity = 1.0
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
        setTitleColor(.white, for: .normal)
//        titleLabel?.font = UIFont(font: .Standard, size: 16.0)
        if let radius = cornerRadius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
        }
        layer.masksToBounds = true
        applyGradient()

//        layer.shadowColor = UIColor(hex: "FFA7A7").cgColor
//        layer.shadowRadius = 4.0
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset.height = 4.0
    }

    @IBInspectable var gradientStartColor: UIColor = UIColor(hex: "FC8787")
    @IBInspectable var gradientEndColor: UIColor = UIColor(hex: "FFA7A7")

    func applyGradient() {
        if shadowAdded {
            return
        }
        shadowAdded = true
        shadowLayer = UIView(frame: self.frame)
        shadowLayer?.backgroundColor = UIColor.clear
        shadowLayer?.layer.shadowColor = UIColor(hex: "FFA7A7").cgColor
        if let gender = UserDefaultManager.getCurrentUserGender() {
            if gender == "M" {
                shadowLayer?.layer.shadowColor = UIColor(hex: "48C8FF").cgColor
            }
        }
        shadowLayer?.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shadowLayer?.layer.shadowOffset.height = 4.0
        shadowLayer?.layer.shadowOpacity = 0.5
        shadowLayer?.layer.shadowRadius = 4
        shadowLayer?.layer.masksToBounds = true
        shadowLayer?.clipsToBounds = false
        self.superview?.addSubview(shadowLayer ?? UIView())
        self.superview?.bringSubviewToFront(self)
    }
}
