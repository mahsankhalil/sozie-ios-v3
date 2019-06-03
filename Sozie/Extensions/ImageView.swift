//
//  ImageView.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 3/5/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import SDWebImage
extension UIImageView {

    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        context.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context)
        let floatAlpha = CGFloat(pixel[3])
        return floatAlpha
    }
}
