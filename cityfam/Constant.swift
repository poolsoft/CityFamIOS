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

// MARK: appDelegate reference
let appDelegate = UIApplication.shared.delegate as!(AppDelegate)

//MARK:- other

let appNavColor:UIColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)


//let eventStore : EKEventStore = EKEventStore()
//
//// 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
//
//eventStore.requestAccess(to: .event) { (granted, error) in
//    
//    if (granted) && (error == nil) {
//        print("granted \(granted)")
//        print("error \(error)")
//        
//        let event:EKEvent = EKEvent(eventStore: eventStore)
//        
//        event.title = "Test Title"
//        event.startDate = Date()
//        event.endDate = Date()
//        event.notes = "This is a note"
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        do {
//            try eventStore.save(event, span: .thisEvent)
//        } catch let error as NSError {
//            print("failed to save event with error : \(error)")
//        }
//        print("Saved Event")
//    }
//    else{
//        
//        print("failed to save event with error : \(error) or access not granted")
//    }
//}
