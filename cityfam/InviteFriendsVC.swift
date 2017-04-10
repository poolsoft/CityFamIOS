//
//  InviteFriendsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class InviteFriendsVC: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets & Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var myFriendsBtn: UIButtonCustomClass!
    @IBOutlet var myContactsBtn: UIButtonCustomClass!
    @IBOutlet var myGroupBtn: UIButtonCustomClass!
    
    let arrContacts = NSMutableArray()
    var myFriendsListArr = [NSDictionary]()
    var myGroupsListArr = [NSDictionary]()

    var searchContactsListArr = [NSDictionary]()
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: UITableView delgates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5//searchContactsListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:InviteFriendsTableViewcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InviteFriendsTableViewcell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK:- Button Actions
    
    @IBAction func tickBtnAction(_ sender: UIButtonFontSize) {
    }
    
    @IBAction func segmentControlBtnAction(_ sender: UIButton) {
        //let button = sender as! UIButtonCustomClass
        
        switch sender.tag {
        case 0:
            self.myFriendsBtn.isSelected = true
            self.myFriendsBtn.backgroundColor = appNavColor
            self.myGroupBtn.isSelected = false
            self.myGroupBtn.backgroundColor = UIColor.clear
            self.myContactsBtn.isSelected = false
            self.myContactsBtn.backgroundColor = UIColor.clear
            break
        case 1:
            self.myContactsBtn.isSelected = true
            self.myContactsBtn.backgroundColor = appNavColor
            self.myFriendsBtn.isSelected = false
            self.myFriendsBtn.backgroundColor = UIColor.clear
            self.myGroupBtn.isSelected = false
            self.myGroupBtn.backgroundColor = UIColor.clear
            self.getMyContacts()
            break
        case 2:
            self.myGroupBtn.isSelected = true
            self.myGroupBtn.backgroundColor = appNavColor
            self.myFriendsBtn.isSelected = false
            self.myFriendsBtn.backgroundColor = UIColor.clear
            self.myContactsBtn.isSelected = false
            self.myContactsBtn.backgroundColor = UIColor.clear
            break
        default:
            break
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        //retreiveEmail()
//        let cnPicker = CNContactPickerViewController()
//        cnPicker.delegate = self
//        self.present(cnPicker, animated: true, completion: nil)
    }

    //retreive
    
    func retreiveEmail(){
        for index in 0 ..< self.arrContacts.count-1 {
            let dict = self.arrContacts[index] as! NSDictionary
            print(dict.value(forKey: "name")!)
            print(dict.value(forKey: "email")!)
        }
    }
    

    //MARK:- Methods
    
    //Get list of phone contacts which have Email address
    func getMyContacts(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let keysToFetch = CNContactFetchRequest(keysToFetch:[CNContactIdentifierKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactBirthdayKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName)])
            // let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactBirthdayKey] as [Any]
            
            //let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try store.enumerateContacts(with: keysToFetch){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                    
                    let arrEmail = contact.emailAddresses as NSArray
                    
                    if arrEmail.count > 0 {
                        
                        let dict = NSMutableDictionary()
                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "name")
                        let emails = NSMutableArray()
                        
                        for index in 0...arrEmail.count-1 {
                            
                            let email = arrEmail.object(at: index)
                            emails.add(email )
                        }
                        dict.setValue(emails, forKey: "email")
                        self.arrContacts.add(dict) // Either retrieve only those contact who have email and store only name and email
                    }
                    //self.arrContacts.add(contact) // either store all contact with all detail and simplifies later on
                    
                }
            }
            catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            print("all contacts:\(self.arrContacts)")
            
            //            print(">>>> Contact list:")
            //            for contact in cnContacts {
            //                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            //                let email = contact.emailAddresses
            //                print("\(fullName): \(contact.phoneNumbers.description)")
            //            }
        })
        
    }
    
    
    func getMyFriends(){
        
    }
    
    func getMyGroups(){
        
    }
    
    // dismissing keyboard on pressing return key
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}



//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        contacts.forEach { contact in
//            for number in contact.emailAddresses {
//                let phoneNumber = number.value
//                print("number is = \(phoneNumber)")
//            }
//        }
//    }
//
//    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//        print("Cancel Contact Picker")
//    }

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


//    lazy var contacts: [CNContact] = {
//        let contactStore = CNContactStore()
//        let keysToFetch = [
//            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//            CNContactEmailAddressesKey,
//            CNContactPhoneNumbersKey] as [Any]//            CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey
//
//        // Get all the containers
//        var allContainers: [CNContainer] = []
//        do {
//            allContainers = try contactStore.containers(matching: nil)
//        } catch {
//            print("Error fetching containers")
//        }
//
//        var results: [CNContact] = []
//
//        // Iterate all containers and append their contacts to our results array
//        for container in allContainers {
//            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//
//            do {
//                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
//                results.append(contentsOf: containerResults)
//                print("results",results)
//            } catch {
//                print("Error fetching results for container")
//            }
//        }
//        return results
//    }()
//

