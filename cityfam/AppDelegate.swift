//
//  AppDelegate.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/16/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//
import UIKit
import MBProgressHUD
import FBSDKLoginKit
import FacebookCore
import Google
import GoogleSignIn
import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInUIDelegate {

    var window: UIWindow?
    var hud:MBProgressHUD!

    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        

        let navController:UINavigationController = self.window?.rootViewController as! UINavigationController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if(UserDefaults.standard.value(forKey: USER_DEFAULT_userId_Key) != nil){
            let tabBarControllerVcObj = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
            navController.pushViewController(tabBarControllerVcObj, animated: true)
        }
        else{
            let secondViewController = mainStoryboard.instantiateViewController(withIdentifier: "logInVC") as! LogInVC
            navController.pushViewController(secondViewController, animated: true)
        }

//        GIDSignIn.sharedInstance().signOut()
//        
//        GIDSignIn.sharedInstance().clientID = "59303853655-jl9hdqnu3mu5e7u2i8mbgfdsk9di5c06.apps.googleusercontent.com"
        //GIDSignIn.sharedInstance().delegate = self
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//        return GIDSignIn.sharedInstance().handleURL(url,sourceApplication: option[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//        annotation: option[UIApplicationOpenURLOptionsAnnotationKey])
//        //return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }


//    //For iOS 8 and older
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
//    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
//    }

    //For iOS 10
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//       // return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
//    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if(url.scheme!.isEqual("fb1080391375424219")) {
            
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
            //        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
            
        else {
            return GIDSignIn.sharedInstance().handle(url as URL!,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        application.applicationIconBadgeNumber = 0
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("\(userInfo)")
        // Print full message.
        
        
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let title = alert["title"] as? NSString {
                    if let body = alert["body"] as? NSString {
                        CommonFxns.showAlert((window?.rootViewController)!, message: "\(title) \n \(body)", title: "Notification")
                    }
                }
            }
        }
        
        
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.setValue(refreshedToken, forKey: "tokenId")
            if UserDefaults.standard.value(forKey: "refreshTokenID") == nil{
                if(UserDefaults.standard.value(forKey: "userId") != nil){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerTokenIdNotification"), object: nil)
                }
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }

    //    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    //    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    //    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        //         With swizzling disabled you must set the APNs token here.
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        
        if let token = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(token)")
            UserDefaults.standard.setValue(token, forKey: "tokenId")
            
            if UserDefaults.standard.value(forKey: "refreshTokenID") == nil{
                if(UserDefaults.standard.value(forKey: "userId") != nil){
                    if (UserDefaults.standard.value(forKey: "refreshTokenID") as! String) !=  token{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "registerTokenIdNotification"), object: nil)
                    }
                }
            }
        }
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: ProgressHUD Methods
    
    func showProgressHUD(view : UIView)->Void{
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideProgressHUD(view : UIView)->Void{
        MBProgressHUD.hide(for: view, animated: true)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        //        let userInfoDict = notification.request.content.userInfo as? NSDictionary
        
        
        
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
}
}

