//
//  Label.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 4/11/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

extension UILabel {
    func lblShadow(color: UIColor, radius: CGFloat, opacity: Float){
//        self.textColor = color
        self.layer.shadowColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
