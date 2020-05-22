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
//import Appsee
import Intercom
import UserNotifications
import CoreLocation
import Firebase
import Analytics
import Branch
import Segment_Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var imageTaken: UIImage?
    var updatedProduct: Product?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var pushToken: String?
    var segmentAnalytics: SEGAnalytics?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, _) in
            // do stuff with deep link data (nav to page, display content, etc)
            if let stage = params?["~stage"] as? String {
                if stage == "forgot_password" {
                    if let token = params?["token"], let userId = params?["user_id"] {
                        var dataDict = [String: Any]()
                        dataDict["user_token"] = token
                        dataDict["user_id"] = userId
                        self.showResetPasswordVC(with: dataDict)
                    }
                }
            }
            print(params as? [String: AnyObject] ?? {})
        }
        print(Bundle.main.infoDictionary?["Configuration"] as! String)
        GIDSignIn.sharedInstance().clientID = "417360914886-kt7feo03r47adeesn8i4udr0i0ofufs0.apps.googleusercontent.com"
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        if UserDefaultManager.isUserLoggedIn() {
//            if UserDefaultManager.checkIfMeasurementEmpty() {
//                self.showMeasuremnetVC()
//            } else {
                fetchUserDetail()
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "tabBarNC")
                self.window?.rootViewController = rootViewController
//            }
        }
        ServerManager.sharedInstance.getBrandList(params: [:]) { (isSuccess, response) in
            if isSuccess {
                let brandList = response as! [Brand]
                _ = UserDefaultManager.saveAllBrands(brands: brandList)
            }
        }
//        Intercom.setApiKey("ios_sdk-a1bcb8310b7c4ccc2937ed6429e6ecfc17b224b0", forAppId:"jevqi9qx")
//        UtilityManager.registerUserOnIntercom()
//        Intercom.setApiKey("ios_sdk-d2d055c16ce67ff20e47efcf6d49f3091ec8acde", forAppId: "txms4v5i")
//        UtilityManager.registerUserOnIntercom()
//        Appsee.start()
//        if let user = UserDefaultManager.getCurrentUserObject() {
//            HubSpotManager.createContact(user: user)
//        }
        UNUserNotificationCenter.current().delegate = self
        self.setupSegment()
        self.perform(#selector(self.createIdentityOnSegment), with: nil, afterDelay: 5.0)
        if UserDefaultManager.getIfFirstTime() {
            SegmentManager.createEventDownloaded()
            UserDefaultManager.setNotFirstTime()
        }
        return true
    }
    @objc func createIdentityOnSegment() {
        if let user = UserDefaultManager.getCurrentUserObject() {
            SegmentManager.createEntity(user: user)
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updateBadge")))
        }
    }
    func fetchUserDetail() {
        if let userId = UserDefaultManager.getCurrentUserId() {
            ServerManager.sharedInstance.getUserProfile(userId: userId) { (isSuccess, response) in
                if isSuccess {
                    let user = response as! User
                    UserDefaultManager.updateUserObject(user: user)
                }
            }
        }
    }
    func setupSegment() {
        var writeKey = "zQT3BYCL9zdEZP7rDseJkFXN63zMzMCI"
        if let betaTester = Bundle.main.infoDictionary?["BETA_TESTER"] as? String {
            if betaTester == "YES" {
                writeKey = "zQT3BYCL9zdEZP7rDseJkFXN63zMzMCI"
//                writeKey = "EctXRhKVtgLSwyWIHuVZPtQSXKjfYhNw"
            } else {
                writeKey = "EctXRhKVtgLSwyWIHuVZPtQSXKjfYhNw"
            }
        } else {
            writeKey = "EctXRhKVtgLSwyWIHuVZPtQSXKjfYhNw"
        }
        let configuration = SEGAnalyticsConfiguration.init(writeKey: writeKey)
        configuration.trackApplicationLifecycleEvents = true
        configuration.recordScreenViews = true
        configuration.use(SEGIntercomIntegrationFactory.instance())
        //Firebase DEV and Prod Environment is setup in (Sozie-Stage -> Edit Scheme -> Build -> Post-Action)
        // A run script is added over there which will replace the google plist file in Built Directory
        configuration.use(SEGFirebaseIntegrationFactory.instance())
//        segmentAnalytics = SEGAnalytics(configuration: configuration)
        SEGAnalytics.setup(with: configuration)
        self.segmentAnalytics = SEGAnalytics.shared()

//        segmentAnalytics?.reset()
    }
    func showMeasuremnetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "MeasurementsVC") as! MeasurementsVC
        rootViewController.isFromSignUp = true
        self.window?.rootViewController = rootViewController
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
//        if url.absoluteString.hasPrefix("sozie://resetpwd") {
//            if let params = url.queryParameters {
//                showResetPasswordVC(with: params)
//            }
//        }
        ApplicationDelegate.shared.application(app, open: url, options: options)
        return true
    }

    func setupLocationManager() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
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
        application.applicationIconBadgeNumber = 0
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
        pushToken = deviceToken.hexString
        updatePushTokenToServer()
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func updatePushTokenToServer() {
        #if !targetEnvironment(simulator)
        if let token = pushToken, token != "" {
            var dataDict = [String: Any]()
            dataDict["device_notify_id"] = token
            ServerManager.sharedInstance.updateUserToken(params: dataDict) { (_, _) in
            }
        }
        #endif
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Intercom.isIntercomPushNotification(userInfo) {
            if application.applicationState == UIApplication.State.inactive || application.applicationState == UIApplication.State.background {
                if UserDefaultManager.isUserLoggedIn() {
                    if UserDefaultManager.checkIfMeasurementEmpty() == false {
                        self.perform(#selector(self.showProfileTab), with: nil, afterDelay: 1.0)
                    }
                }
            }
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "updateBadge")))
            Intercom.handlePushNotification(userInfo)
        }
        completionHandler(.noData)
    }
    @objc func showProfileTab() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "showProfileTab")))
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
extension AppDelegate: CLLocationManagerDelegate {
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        currentLocation = locations.last
        locationManager?.stopMonitoringSignificantLocationChanges()
        print("locations = \(String(describing: currentLocation))")
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "LocationAvailable")))

    }
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation = nil
        print("Error")
    }
}
