//
//  DZGradientButton.swift
//  Sozie
//
//  Created by Danial Zahid on 18/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

@IBDesignable class DZGradientButton: UIButton {

    var shadowAdded: Bool = false
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [gradientStartColor.cgColor,gradientEndColor.cgColor]
        gradient.opacity = 1.0
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5);
        layer.insertSublayer(gradient, at: 0)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(font: .Standard, size: 16.0)
        
        layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
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
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor(hex: "FFA7A7").cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset.height = 4.0
        shadowLayer.layer.shadowOpacity = 1.0
        shadowLayer.layer.shadowRadius = 4
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubviewToFront(self)
    }
 

}
