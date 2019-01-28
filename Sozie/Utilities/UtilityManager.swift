//
//  UtilityManager.swift
//  MyDocChat
//
//  Created by Danial Zahid on 29/05/15.
//  Copyright (c) 2015 DanialZahid. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class UtilityManager: NSObject {
    
    static func stringFromNSDateWithFormat(date: NSDate, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date as Date)
    }
    
    static func dateFromStringWithFormat(date: String, format: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)! as NSDate
    }
    
    static func serverDateStringFromAppDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.appDateFormat
        dateFormatter.timeZone = NSTimeZone.local
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Constant.serverDateFormat
        newDateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return newDateFormatter.string(from: dateFormatter.date(from: dateString)!)
    }
    
    //MARK: - Other Methods
  
    static func openImagePickerActionSheetFrom(vc: UIViewController) {
        let alert = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            UtilityManager.openCameraFrom(vc: vc)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            UtilityManager.openGalleryFrom(vc: vc)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func openCameraFrom(vc : UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            vc.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func openGalleryFrom(vc : UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        vc.present(imagePicker, animated: true, completion: nil)
    }
    
    static func showActivityControllerWith(objectsToShare : [Any] , vc : UIViewController) {
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        let excludedActivities = [UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.message, UIActivity.ActivityType.mail, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToTencentWeibo]
        
        activityController.excludedActivityTypes = excludedActivities
        
        vc.present(activityController, animated: true, completion: nil)
    }
  
    static func activityIndicatorForView(view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.remakeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-40)
        }
        
        return activityIndicator
    }
    
    static func showErrorMessage(body: String, in controller: UIViewController) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: body, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (okBtn) in
            
        }
        alert.addAction(okBtnAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showMessageWith(title : String , body : String, in controller : UIViewController , block : (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (okBtn) in
            block?()
        }
        alert.addAction(okBtnAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
//    static func showMessageWith(title : String , body : String, in controller : UIViewController) {
//        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
//        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (okBtn) in
//            
//        }
//        alert.addAction(okBtnAction)
//        controller.present(alert, animated: true) {
//            
//        }
//    }
    
    static func showSuccessMessage(body: String, in controller: UIViewController) {
        SVProgressHUD.dismiss()
        
        let alert = UIAlertController(title: "Success", message: body, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (okBtn) in
            
        }
        alert.addAction(okBtnAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func noDataViewWithText(errorMessage: String, on view: UIView) {
        let layer = CALayer()
        layer.frame = view.bounds
    }
    
    static func uniqueKeyWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    static func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool, short: Bool = false) -> String {
        
        let calendar = NSCalendar.current
        let unitFlags : Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let now = NSDate()
        let earliest = now.earlierDate(date as Date) as Date
        let latest = (earliest == now as Date) ? date as Date : now as Date
        
        //        Components(unitFlags, fromDate: earliest, toDate: latest) else { return ""}
        
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        //        let ccc = calendar.datecom
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfYear = components.weekOfYear ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        if (year >= 2) {
            return "\(year) years ago"
        } else if (year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (month >= 2) {
            return short ? "1 m" : "\(month) months ago"
        } else if (month >= 1){
            if (numericDates){
                return short ? "1 m" : "1 month ago"
            } else {
                return short ? "1 m" : "Last month"
            }
        }
//        else if (weekOfYear >= 2) {
//            return "\(weekOfYear) weeks ago"
//        }
        else if (weekOfYear >= 1){
            return short ? "\(day + (weekOfYear * 7)) d" : "\(day + (weekOfYear * 7)) days ago"
        }
        else if (day >= 2) {
            return short ? "\(day) d" : "\(day) days ago"
        } else if (day >= 1){
            if (numericDates){
                return short ? "1 d" : "1 day ago"
            } else {
                return short ? "1 d" : "Yesterday"
            }
        } else if (hour >= 2) {
            return short ? "\(hour) h" :  "\(hour) hours ago"
        } else if (hour >= 1){
            if (numericDates){
                return short ? "1 h" :  "1 hour ago"
            } else {
                return short ? "1 h" : "An hour ago"
            }
        } else if (minute >= 2) {
            return short ? "\(minute) m" :  "\(minute) minutes ago"
        } else if (minute >= 1){
            if (numericDates){
                return short ? "1 m" : "1 minute ago"
            } else {
                return short ? "1 m" : "A minute ago"
            }
        } else if (second >= 3) {
            return short ? "\(second) s" : "\(second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

// MARK: - Image Scaling.
extension UIImage {

    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
