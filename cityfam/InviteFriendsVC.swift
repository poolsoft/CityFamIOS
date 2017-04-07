//
//  InviteFriendsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InviteFriendsVC: UIViewController,UITextFieldDelegate {

    let arrContacts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // dismissing keyboard on pressing return key
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
//    //Get Contacts with email
//    
//    func getAllContacts() {
//        
//        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts) as CNAuthorizationStatus
//        
//        if status == CNAuthorizationStatus.denied {
//            
//            let alert = UIAlertController(title:nil, message:"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts", preferredStyle:UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil))
//            self.presentViewController(alert, animated:true, completion:nil)
//            return
//        }
//        
//        let store = CNContactStore()
//        store.requestAccessForEntityType(CNEntityType.Contacts) { (granted:Bool, error:Error?)  -> Void in
//            
//            if !granted {
//                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                    // user didn't grant access;
//                    // so, again, tell user here why app needs permissions in order  to do it's job;
//                    // this is dispatched to the main queue because this request could be running on background thread
//                })
//                return
//            }
//            
//            
//            let request = CNContactFetchRequest(keysToFetch:[CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName)])
//            
//            do {
//                
//                try store.enumerateContactsWithFetchRequest(request, usingBlock: { (contact:CNContact, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//                    
//                    let arrEmail = contact.emailAddresses as NSArray
//                    
//                    if arrEmail.count > 0 {
//                        
//                        let dict = NSMutableDictionary()
//                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "name")
//                        let emails = NSMutableArray()
//                        
//                        for index in 0...arrEmail.count {
//                            
//                            let email:CNLabeledValue = arrEmail.objectAtIndex(index) as! CNLabeledValue
//                            emails .addObject(email.value as! String)
//                        }
//                        dict.setValue(emails, forKey: "email")
//                        arrContacts.addObject(dict) // Either retrieve only those contact who have email and store only name and email
//                    }
//                    arrContacts.addObject(contact) // either store all contact with all detail and simplifies later on
//                })
//            } catch {
//                
//                return;
//            }
//        }
//    }
    //retreive
    
    func retreiveEmail(){
        for index in 0 ..< self.arrContacts.count {
            
            let dict = self.arrContacts[index] as! NSDictionary
            print(dict.value(forKey: "name") as! String)
            print(dict.value(forKey: "email") as! String)
        }
    }
}
