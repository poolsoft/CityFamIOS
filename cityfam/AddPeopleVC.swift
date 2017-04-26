//
//  AddPeopleVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class AddPeopleVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GetMyFriendsListServiceAlamofire {
    
    //MARK:- Outlets & Propeties
    
    @IBOutlet var myFriendsBtn: UIButtonCustomClass!
    @IBOutlet var tickBtn: UIButtonFontSize!
    @IBOutlet var myContactsBtn: UIButtonCustomClass!
    @IBOutlet var searchTxtField: UITextFieldCustomClass!
    @IBOutlet var myFriendsTableView: UITableView!
    @IBOutlet var myContactsTableView: UITableView!
    
    var myFriendsListArr = [NSDictionary]()
    var myContactsListArr = [NSDictionary]()
    var selectedSegmentValue = Int()
    var isComingFromProfileScreen = Bool()
    let arrOfPhoneContacts = NSMutableArray()

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intial Setup
        selectedSegmentValue = 1
        self.myFriendsTableView.isHidden = false
        self.myContactsTableView.isHidden = true
        self.tickBtn.isHidden = true
        
        //Get friends list Api call
        self.getMyFriendsListApi()
    }
    
    //MARK:- Methods
    
    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    ////GetMy FriendsList Api Result
    func getMyFriendsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                let resultArr = result.value(forKey: "result") as! [NSDictionary]
                
                if self.selectedSegmentValue == 1{
                    self.myFriendsListArr = resultArr
                    self.myFriendsTableView.reloadData()
                }
                else{
                    self.myContactsListArr = resultArr
                    self.myContactsTableView.reloadData()
                }
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //GetMy FriendsList Api call
    func getMyFriendsListApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            FriendsAlamofireIntegration.sharedInstance.getMyFriendsListServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getMyFriendsListApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
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
                        self.arrOfPhoneContacts.add(dict) // Either retrieve only those contact who have email and store only name and email
                    }
                    //self.arrContacts.add(contact) // either store all contact with all detail and simplifies later on
                    
                }
            }
            catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            print("all contacts:\(self.arrOfPhoneContacts)")
            
            //            print(">>>> Contact list:")
            //            for contact in cnContacts {
            //                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            //                let email = contact.emailAddresses
            //                print("\(fullName): \(contact.phoneNumbers.description)")
            //            }
        })
        
    }

    //retreive
    
    func retreiveEmail(){
        for index in 0 ..< self.arrOfPhoneContacts.count-1 {
            let dict = self.arrOfPhoneContacts[index] as! NSDictionary
            print(dict.value(forKey: "name")!)
            print(dict.value(forKey: "email")!)
        }
    }
    
    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1{
            return (myFriendsListArr[section].value(forKey: "friends") as! [NSDictionary]).count
        }
        else{
            return myContactsListArr.count
        }
    }
    
    //    result =     (
    //    {
    //    friends =             (
    //      {
    //      emailId = "Ankita.mittra@imarkinfotech.com";
    //      userId = 14;
    //      userImageUrl = "";
    //      userName = "Ankita Mittra";
    //      }
    //    );
    //    letters = A;
    //    },
    //    {
    //    friends =             (
    //    {
    //    emailId = "swaran.lata@imarkinfotech.com";
    //    userId = 1;
    //    userImageUrl = "http://imarkclients.com/cityfam/wp-content/uploads/2017/04/1492155174.png";
    //    userName = "Swaran Lata";
    //    }
    //    );
    //    letters = S;
    //    }
    //    );
    //    success = 1;
    //}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.myFriendsListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.myFriendsListArr[section].value(forKey: "letters") as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! AddPeopleMyFriendsTableViewCell
            
           // let dict = self.myFriendsListArr[indexPath.section].value(forKey: "friends") as? [NSDictionary][indexPath.row]

            let sectionArr = self.myFriendsListArr[indexPath.section].value(forKey: "friends") as! [NSDictionary]
            
            let dict = sectionArr[indexPath.row]
            
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String
            
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myContactsCell", for: indexPath) as! AddPeopleMyContactsTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        //        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK:- Button Actions
    
    @IBAction func segmentControlBtnAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            myFriendsBtn.isSelected = true
            myFriendsBtn.backgroundColor = appNavColor
            myContactsBtn.isSelected = false
            myContactsBtn.backgroundColor = UIColor.clear
            selectedSegmentValue = 1
            self.myFriendsTableView.isHidden = false
            self.myContactsTableView.isHidden = true
        }
        else{
            myContactsBtn.isSelected = true
            myContactsBtn.backgroundColor = appNavColor
            myFriendsBtn.isSelected = false
            myFriendsBtn.backgroundColor = UIColor.clear
            selectedSegmentValue = 1
            self.myFriendsTableView.isHidden = true
            self.myContactsTableView.isHidden = false
            self.getMyContacts()
            
            if self.myContactsListArr.count == 0{
                //get my contacts
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
