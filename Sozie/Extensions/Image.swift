//
//  Image.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/5/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit

public extension UIImage {
/**
     Suitable size for specific height or width to keep same image ratio
     */
    func suitableSize(heightLimit: CGFloat? = nil,
                      widthLimit: CGFloat? = nil ) -> CGSize? {
        if let height = heightLimit {
            let width = (height / self.size.height) * self.size.width
            return CGSize(width: width, height: height)
        }
        if let width = widthLimit {
            let height = (width / self.size.width) * self.size.height
            return CGSize(width: width, height: height)
        }
        return nil
    }
    func resizeImage(newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func circularImage(_ radius: CGFloat) -> UIImage? {
        var imageView = UIImageView()
        if self.size.width > self.size.height {
            imageView.frame =  CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
            imageView.image = self
            imageView.contentMode = .scaleAspectFit
        } else { imageView = UIImageView(image: self) }
        var layer: CALayer = CALayer()
        
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}
