//
//  Styles.swift
//  edX
//
//  Created by Danial Zahid on 25/05/2015.
//  Copyright (c) 2015 edX. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import MaterialTextField
struct ShadowStyle {
    let angle: Int //degrees
    let color: UIColor
    let opacity: CGFloat //0..1
    let distance: CGFloat
    let size: CGFloat

    var shadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = color.withAlphaComponent(opacity)
        shadow.shadowOffset = CGSize(width: cos(CGFloat(angle) / 180.0 * CGFloat(Double.pi)), height: sin(CGFloat(angle) / 180.0 * CGFloat(Double.pi)))
        shadow.shadowBlurRadius = size
        return shadow
    }
}

enum Font : String {
    case Standard = "SegoeUI"
    case Bold = "SegoeUI-Bold"
    case SemiBold = "SegoeUI-SemiBold"
}

class Styles {
    
    static let sharedStyles = Styles()
    
    public func applyGlobalAppearance() {
        //Probably want to set the tintColor of UIWindow but it didn't seem necessary right now
        
//        UINavigationBar.appearance().barTintColor = UIColor.init(patternImage: UIImage(named: "login-bg")!)
        UINavigationBar.appearance().barTintColor = Styles.sharedStyles.primaryColor
        UINavigationBar.appearance().tintColor = .white
        UIToolbar.appearance().tintColor = Styles.sharedStyles.primaryColor
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UITextField.appearance().tintColor = .white
        
//        UISegmentedControl.appearance().tintColor = UIColor.blue
//        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-30, -30), for:UIBarMetrics.default)
        
        UINavigationBar.appearance().isTranslucent = false
        
        let attributes = [NSAttributedString.Key.font: UIFont(font: Font.SemiBold, size: 15.0)!,
                          NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    
    public var progressBarTintColor : UIColor {
        return UIColor(red: CGFloat(126.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(143.0/255.0), alpha: CGFloat(1.00))
    }
    
    ///**Warning:** Not from style guide. Do not add more uses
    public var progressBarTrackTintColor : UIColor {
        return UIColor(red: CGFloat(223.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(228.0/255.0), alpha: CGFloat(1.00))
    }
    
    public var primaryColor: UIColor {
        return UIColor(hex: "FC8787")
    }
    
    public var primaryGreyColor : UIColor {
        return UIColor(white: 0.2, alpha: 1.0)
    }


    var standardTextViewInsets : UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    var standardFooterHeight : CGFloat {
        return 44
    }
    
    var standardVerticalMargin : CGFloat {
        return 8.0
    }
    
    var standardHorizontalMargin : CGFloat {
        return 8.0
    }
    
    var boxCornerRadius : CGFloat {
        return 8.0
    }
    
    var buttonCornerRadius : CGFloat {
        return 6.0
    }

}

extension UIView {
    func applyStandardContainerViewStyle() {
        backgroundColor = UIColor.white
        layer.cornerRadius = Styles.sharedStyles.boxCornerRadius
        layer.masksToBounds = true
    }
    
    func applyStandardContainerViewShadow() {
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = 1.0;
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1;
        layer.masksToBounds = false

    }
    
    func applyShadowWith(radius : CGFloat , shadowOffSet : CGSize , opacity : Float)
    {
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowRadius = radius
        layer.shadowOffset = shadowOffSet
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func applyCornerRadiusAndBorder() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(hex: "BFBFBF").cgColor
        layer.masksToBounds = true
    }
    
    func applyStandardBorder(hexColor : String = "DADADA") {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(hex: hexColor).cgColor
    }
    func makeViewCircle() {
        layer.cornerRadius = frame.size.width/2.0
        clipsToBounds = true
    }
}

extension MFTextField {
    
    func setupAppDesign() {
        self.underlineColor = UIColor(hex: "DADADA")
        self.placeholderColor = UIColor(hex: "888888")
        self.tintColor = UIColor(hex: "FC8888")
        self.placeholderFont = UIFont(name: "SegoeUI", size: 14.0)
    }
    
    func applyRightVuLblWith(title : String ) {
        let lbl = InsetLabel(frame: CGRect(x: 0.0, y: 0.0, width:38.0 , height: 40.0))
        lbl.text = title
        lbl.textAlignment = .right
        lbl.font = UIFont(name: "SegoeUI", size: 12.0)
        lbl.textColor = UIColor(hex: "323232")
        lbl.rightInset = 8.0
        lbl.topInset = 17.0
        lbl.text = title
        self.rightViewMode = .always
        self.rightView = lbl
    }
}

extension UIButton {
    
    func styleFilledSignUp() {
        backgroundColor = UIColor.white
        setTitleColor(UIColor(hex: "3FB0AC"), for:.normal)
        titleLabel?.font = UIFont(font: Font.Standard, size: 15.0)
        layer.cornerRadius = Styles.sharedStyles.buttonCornerRadius
    }
    
    func applyButtonSelected(){
        self.layer.borderColor = UIColor(displayP3Red: 252.0/255.0, green: 135.0/255.0, blue: 135.0/255.0, alpha: 0.8).cgColor
        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1.0
        
        self.clipsToBounds = false
    }
    
    func applyButtonUnSelected(){
        self.layer.borderColor = UIColor(displayP3Red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 0.8).cgColor
        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
    
    func applyButtonSelectedWithoutBorder() {
        self.titleLabel?.font = UIFont(font: Font.Bold, size: 16.0)
        self.setTitleColor(UIColor(hex: "FC8888"), for: .normal)
    }
    
    func applyButtonUnSelectedWithoutBorder() {
        self.titleLabel?.font = UIFont(font: Font.Standard, size: 16.0)
        self.setTitleColor(UIColor(hex: "323232"), for: .normal)
    }
    
    func applyButtonShadow() {
        self.layer.shadowColor = UIColor(hex: "FFA7A7").cgColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset.height = 4.0
    }
}

extension UITextField {
    func styleStandardField() {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
    }
}

extension UIFont {
    convenience init?(font: Font, size: CGFloat) {
        self.init(name: font.rawValue, size: size)
    }
}

//Standard Search Bar styles
extension UISearchBar {
    func applyStandardStyles(withPlaceholder placeholder : String? = nil) {
        self.placeholder = placeholder
        self.showsCancelButton = false
        self.searchBarStyle = .default
        self.backgroundColor = UIColor.white
    }
}

//Convenience computed properties for margins
var StandardHorizontalMargin : CGFloat {
    return Styles.sharedStyles.standardHorizontalMargin
}

var StandardVerticalMargin : CGFloat {
    return Styles.sharedStyles.standardVerticalMargin
}

//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

protocol Blurable {
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    func removeFromSuperview()
    func blur(blurRadius: CGFloat)
}

class BlurOverlay: UIImageView {
}

struct BlurableKey {
    static var blurable = "blurable"
}

extension Blurable {
    func blur(blurRadius: CGFloat) {
        if self.superview == nil {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur"),
            let this = self as? UIView else {
            return
        }
        
        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage
        
        let boundingRect = CGRect(x:0,
                                  y: 0,
                                  width: frame.width,
                                  height: frame.height)
        
        let cgImage = ciContext.createCGImage(result, from: boundingRect)
        
        let filteredImage = UIImage(cgImage: cgImage!)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = UIView.ContentMode.left
        
        if let superview = superview as? UIStackView,
            let index = (superview as UIStackView).arrangedSubviews.index(of: this) {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        } else {
            blurOverlay.frame.origin = frame.origin
            
            UIView.transition(from: this,
                              to: blurOverlay,
                              duration: 0.2,
                              options: .curveEaseIn,
                              completion: nil)
        }
        
        objc_setAssociatedObject(this,
                                 &BlurableKey.blurable,
                                 blurOverlay,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

class InsetLabel: UILabel {
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    var leftInset = CGFloat(0)
    var rightInset = CGFloat(0)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

extension UIButton: Blurable {
}
