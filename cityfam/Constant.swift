//
//  Constant.swift
//  HungerPass
//
//  Created by Piyush Gupta on 9/23/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

// MARK: userDefault
let userDefault = UserDefaults.standard
let USER_DEFAULT_userId_Key = "userID"
let USER_DEFAULT_emailId_Key = "emailID"
let USER_DEFAULT_userName_Key = "userName"
let USER_DEFAULT_LOGIN_CHECK_Key = "Login"
let USER_DEFAULT_FireBaseToken = "fireBaseTokenId"

// local strings

let logoutMessage = "Are you sure want to logout ?"
let yesBtnTitle = "Yes"
let noBtnTitle = "No"
let okBtnTitle = "OK"
let cancelBtnTitle = "cancel"
let errorAlertTitle = "error"
let successAlertTitle = "success"
let publicButtonDescription = "Everyone on cityfam can see this."
let privateButtonDescription = "Only your invited people can see this."
let friendsButtonDescription = "Only your friends can see this."

func getLoginUserId() -> String {
    let usrDefault = UserDefaults.standard
    let usrId = usrDefault.value(forKey: USER_DEFAULT_userId_Key) as! String
    return usrId
}

let baseUrl = ""

// MARK: appDelegate reference
let applicationDelegate = UIApplication.shared.delegate as!(AppDelegate)


// MARK: showAlert Function
func showAlert (_ reference:UIViewController, message:String, title:String){
    var alert = UIAlertController()
    if title == "" {
        alert = UIAlertController(title: nil, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    else{
        alert = UIAlertController(title: title, message: message,preferredStyle: UIAlertControllerStyle.alert)
    }
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    reference.present(alert, animated: true, completion: nil)
    
}

