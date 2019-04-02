//
//  AppDelegate.swift
//  Sozie
//
//  Created by Danial Zahid on 17/12/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Appsee
import Intercom
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var imageTaken: UIImage?
    var updatedProduct: Product?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "943339111983-3cca64ei8g4gukhudc5lurr6cpi0k91f.apps.googleusercontent.com"
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)

        if UserDefaultManager.isUserLoggedIn() {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "tabBarNC")
            self.window?.rootViewController = rootViewController
        }
        Intercom.setApiKey("ios_sdk-d2d055c16ce67ff20e47efcf6d49f3091ec8acde", forAppId: "txms4v5i")
        UtilityManager.registerUserOnIntercom()
        Appsee.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("sozie://resetpwd") {
            if let params = url.queryParameters {
                showResetPasswordVC(with: params)
            }
        }
        if let handled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options) {
            return handled
        }
        return true
    }

    // Respond to Universal Links
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
                print("Notifications permission granted.")
            } else {
                print("Notifications permission denied because: \(error?.localizedDescription ?? "").")
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Intercom.setDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Intercom.isIntercomPushNotification(userInfo) {
            Intercom.handlePushNotification(userInfo)
        }
        completionHandler(.noData)
    }

    func showResetPasswordVC(with params: [String: Any]) {
        guard let resetVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC else { return }
        resetVC.params = params

        if let presentedVC = self.window?.rootViewController?.presentedViewController {
            presentedVC.present(resetVC, animated: true, completion: nil)
        } else {
            self.window?.rootViewController?.present(resetVC, animated: true, completion: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
