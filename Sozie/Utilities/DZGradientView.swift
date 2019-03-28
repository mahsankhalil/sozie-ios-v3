//
//  GradientView.swift
//  Shopify
//
//  Created by Danial Zahid on 9/28/15.
//  Copyright © 2015 Danial Zahid. All rights reserved.
//

import UIKit

@IBDesignable class DZGradientView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.opacity = 1.0
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }

    @IBInspectable var gradientStartColor: UIColor = UIColor(hex: "FC8787")
    @IBInspectable var gradientEndColor: UIColor = UIColor(hex: "FFA7A7")
}
