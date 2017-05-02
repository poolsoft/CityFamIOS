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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInUIDelegate {

    var window: UIWindow?
    var hud:MBProgressHUD!

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

