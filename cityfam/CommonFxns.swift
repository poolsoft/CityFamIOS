//
//  CommonFxns.swift
//  cityfam
//
//  Created by i mark on 05/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration

class CommonFxns: NSObject {
    
    //MARK:- Common methods
    
    //Fetch userId from UserDefault
    class func getLoginUserId() -> String {
        let usrDefault = UserDefaults.standard
        let usrId = usrDefault.value(forKey: USER_DEFAULT_userId_Key) as! String
        return usrId
    }
    
    //Show Alert view with message
    class func showAlert (_ reference:UIViewController, message:String, title:String){
        var alert = UIAlertController()
        if title == "" {
            alert = UIAlertController(title: nil, message: message,preferredStyle: UIAlertControllerStyle.alert)
        }
        else{
            alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
        }
        alert.addAction(UIAlertAction(title: okBtnTitle, style: UIAlertActionStyle.default, handler: nil))
        reference.present(alert, animated: true, completion: nil)
    }
    
    //Check internet Connectivity
    class func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    //Remove extra whiteSpaces from text
    class func trimString(string:String) -> String{
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    //Check email validations
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
