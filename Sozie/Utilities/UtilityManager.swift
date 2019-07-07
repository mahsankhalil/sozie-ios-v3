//
//  UtilityManager.swift
//  MyDocChat
//
//  Created by Danial Zahid on 29/05/15.
//  Copyright (c) 2015 DanialZahid. All rights reserved.
//

import UIKit
//import SnapKit
import SVProgressHUD
import EasyTipView
//import Intercom
import Photos
class UtilityManager: NSObject {

    static func tipViewGlobalPreferences() -> EasyTipView.Preferences {
        var preferences = EasyTipView.globalPreferences
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hex: "5CCEC4")
        preferences.drawing.font = UIFont(name: "SegoeUI", size: 11)!
        preferences.drawing.textAlignment = NSTextAlignment.left
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.animating.dismissDuration = 1.0
        preferences.drawing.arrowPosition = .bottom
        preferences.drawing.cornerRadius = 10.0
        preferences.positioning.maxWidth = 143
        return preferences
    }
    static func stringFromNSDateWithFormat(date: NSDate, format: String) -> String {
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
    static func changeRootVCToLoginNC() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        guard let rootViewController = window.rootViewController else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCOntroller = storyboard.instantiateViewController(withIdentifier: "LandingViewController")
        viewCOntroller.view.frame = rootViewController.view.frame
        viewCOntroller.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = viewCOntroller
        }, completion: nil)
    }
    // MARK: - Other Methods
    static func openImagePickerActionSheetFrom(viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            UtilityManager.openCameraFrom(viewController: viewController)
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            UtilityManager.openGalleryFrom(viewController: viewController)
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
    static func openCameraFrom(viewController: UIViewController) {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    imagePicker.allowsEditing = false
                    viewController.present(imagePicker, animated: true, completion: nil)
                } else {
                    let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    viewController.present(alert, animated: true, completion: nil)
                }
            } else {
                UtilityManager.showPermissionAlertWith(title: "Camera Unavailable", message: "Please check to see if permissions granted in settings.", viewController: viewController)
            }
        }
    }

    static func openGalleryFrom(viewController: UIViewController) {
        //Photos
        PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.allowsEditing = false
                viewController.present(imagePicker, animated: true, completion: nil)
            } else {
                UtilityManager.showPermissionAlertWith(title: "Gallery Unavailable!", message: "Please check to see if permissions granted in settings.", viewController: viewController)
            }
        })
    }
    static func showPermissionAlertWith(title: String, message: String, viewController: UIViewController) {
        let permissionAlertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil) //(url as URL)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        permissionAlertController .addAction(settingsAction)
        permissionAlertController .addAction(cancelAction)
        viewController.present(permissionAlertController, animated: true, completion: nil)
    }

    static func showActivityControllerWith(objectsToShare: [Any], viewController: UIViewController) {
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        let excludedActivities = [UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToTencentWeibo]

        activityController.excludedActivityTypes = excludedActivities

        viewController.present(activityController, animated: true, completion: nil)
    }

    static func showErrorMessage(body: String, in controller: UIViewController) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: body, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
        }
        alert.addAction(okBtnAction)
        controller.present(alert, animated: true, completion: nil)
    }

    static func showMessageWith(title: String, body: String, in controller: UIViewController, okBtnTitle: String = "OK", cancelBtnTitle: String? = nil, dismissAfter: Int? = nil, block: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okBtnAction = UIAlertAction(title: okBtnTitle, style: .default) { (_) in
            block?()
        }
        alert.addAction(okBtnAction)
        if let cancelTite = cancelBtnTitle {
            let cancelAction = UIAlertAction(title: cancelTite, style: .cancel)
            alert.addAction(cancelAction)
        }
        controller.present(alert, animated: true, completion: nil)
        if let seconds = dismissAfter {
            let dispatchAfter = DispatchTimeInterval.seconds(seconds)
            let when = DispatchTime.now() + dispatchAfter
            DispatchQueue.main.asyncAfter(deadline: when) {
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }

        }
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
        let okBtnAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
        }
        alert.addAction(okBtnAction)
        controller.present(alert, animated: true, completion: nil)
    }

    static func noDataViewWithText(errorMessage: String, on view: UIView) {
        let layer = CALayer()
        layer.frame = view.bounds
    }

    static func uniqueKeyWithLength(len: Int) -> NSString {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString: NSMutableString = NSMutableString(capacity: len)
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }

    static func delay(delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
//
    static func timeAgoSinceDate(date: NSDate, numericDates: Bool, short: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
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
        if year >= 2 {
            return "\(year) years ago"
        } else if year >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if month >= 2 {
            return short ? "1 m" : "\(month) months ago"
        } else if month >= 1 {
            if numericDates {
                return short ? "1 m" : "1 month ago"
            } else {
                return short ? "1 m" : "Last month"
            }
        }
//        else if (weekOfYear >= 2) {
//            return "\(weekOfYear) weeks ago"
//        }
        else if weekOfYear >= 1 {
            return short ? "\(day + (weekOfYear * 7)) d" : "\(day + (weekOfYear * 7)) days ago"
        } else if day >= 2 {
            return short ? "\(day) d" : "\(day) days ago"
        } else if day >= 1 {
            if numericDates {
                return short ? "1 d" : "1 day ago"
            } else {
                return short ? "1 d" : "Yesterday"
            }
        } else if hour >= 2 {
            return short ? "\(hour) h" :  "\(hour) hours ago"
        } else if hour >= 1 {
            if numericDates {
                return short ? "1 h" :  "1 hour ago"
            } else {
                return short ? "1 h" : "An hour ago"
            }
        } else if minute >= 2 {
            return short ? "\(minute) m" :  "\(minute) minutes ago"
        } else if minute >= 1 {
            if numericDates {
                return short ? "1 m" : "1 minute ago"
            } else {
                return short ? "1 m" : "A minute ago"
            }
        } else if second >= 3 {
            return short ? "\(second) s" : "\(second) seconds ago"
        } else {
            return "Just now"
        }
    }
//    static func registerUserOnIntercom() {
//        if let user = UserDefaultManager.getCurrentUserObject() {
//            Intercom.registerUser(withUserId: String(user.userId), email: user.email)
//        } else {
//            Intercom.registerUnidentifiedUser()
//        }
//    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
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
        scaledImageRect.size.width = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
