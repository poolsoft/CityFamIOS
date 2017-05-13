//
//  AddPeopleVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class AddPeopleVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GetMyFriendsListServiceAlamofire,MyContactsCellProtocol,MyFriendCellProtocol,AddMembersToGroupServiceAlamofire,GetMyContactsWithStatusServiceAlamofire {
    
    //MARK:- Outlets & Propeties
    
    @IBOutlet var myFriendsBtn: UIButtonCustomClass!
    @IBOutlet var tickBtn: UIButtonFontSize!
    @IBOutlet var myContactsBtn: UIButtonCustomClass!
    @IBOutlet var searchTxtField: UITextFieldCustomClass!
    @IBOutlet var myFriendsTableView: UITableView!
    @IBOutlet var myContactsTableView: UITableView!
    @IBOutlet var titleLbl: UILabelFontSize!
    
    var myFriendsListArr = [NSDictionary]()
    var myContactsListArr = [NSDictionary]()
    var selectedSegmentValue = Int()
    var groupId = String()
    let arrOfPhoneContacts = NSMutableArray()
    var listOfContactsAddToGroup = [String]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intial Setup
        selectedSegmentValue = 1
        self.myFriendsTableView.isHidden = false
        self.myContactsTableView.isHidden = true
        
        self.tickBtn.addTarget(self, action: #selector(AddPeopleVC.tickBtnAction(sender:)), for: .touchUpInside)
        //Get friends list Api call
        self.getMyFriendsListApi()
        self.getMyContacts()
    }
    
    func tickBtnAction(sender:UIButton){
        self.addMemberToGroupApi()
    }
    
    //MARK:- Methods
    
//    func sortArrayOfString(arrOfDicts : [NSDictionary])->[String]{
//        
//        var arr = [String]()
//        
//        for i in 0..<arrOfDicts.count{
//                arr.append(arrOfDicts[i].value(forKey: "userName") as! String)
//        }
//    
//        let b = arr.map{ $0.lowercased() }
//        
//        let c = b.sorted()
//        let d = c.map{ $0[$0.startIndex]}
//        
//        var dictionary:[String:[String]] = [:]
//        _ = d.map{ initial in
//            
//            let clustered = c.filter{$0.hasPrefix("\(initial)")}
//            dictionary.updateValue(clustered, forKey:"\(initial)")
//        }
//        print("\(dictionary)")
//        
//        return arr
//    }
    
    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //GetMy FriendsList Api Result
    func getMyFriendsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                let resultArr = result.value(forKey: "result") as! [NSDictionary]
                
                if self.selectedSegmentValue == 1{
                    
                    var dict = NSMutableDictionary()
                    for i in 0..<resultArr.count{
                        dict = resultArr[i].mutableCopy() as! NSMutableDictionary
                        dict.setObject(0, forKey: "state" as NSCopying)
                        self.myFriendsListArr.append(dict)
                    }
                    self.myFriendsTableView.reloadData()
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
    
    
    //Get My Contacts With Status Api Result
    func getMyContactsWithStatusApiResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                let resultArr = result.value(forKey: "result") as! [NSDictionary]

            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Get My Contacts With Status Api call
    func getMyContactsWithStatusApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            let contactsArrToSend = [NSDictionary]()
            
            let parameters = ["userId":"49",
                              "emailId":contactsArrToSend] as [String : Any]
            FriendsAlamofireIntegration.sharedInstance.getMyContactsWithStatusServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getMyContactsWithStatusApi(parameters: parameters)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //AddMembersToGroup Api Result
    func addMembersToGroupResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGroupDetailNotification"), object: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //AddMembersToGroup Api call
    func addMemberToGroupApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.addMembersToGroupServiceDelegate = self
            
            let parameters = ["userId": UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                              "groupId": groupId,
                              "emailIdArray": self.listOfContactsAddToGroup] as [String : Any]

            FriendsAlamofireIntegration.sharedInstance.addMemberToGroupApi(parameters: parameters)
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
                        dict.setValue((contact.givenName+" "+contact.familyName), forKey: "userName")
                        let emails = NSMutableArray()
                        
                        for index in 0...arrEmail.count-1 {
                            
                            let email = arrEmail.object(at: index)
                            emails.add(email )
                        }
                        dict.setValue(emails, forKey: "emailId")
                        self.arrOfPhoneContacts.add(dict) // Either retrieve only those contact who have email and store only name and email
                    }
                    //self.arrContacts.add(contact) // either store all contact with all detail and simplifies later on
                    
                }
            }
            catch let error {
                NSLog("Fetch contact error: \(error)")
            }
           // print("all contacts:\(self.arrOfPhoneContacts)")
            
            //            print(">>>> Contact list:")
            //            for contact in cnContacts {
            //                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
            //                let email = contact.emailAddresses
            //                print("\(fullName): \(contact.phoneNumbers.description)")
            //            }
            
        })
    }

    //retreive
    
    func retreiveEmail()->[NSDictionary]{
        var dictArr = [NSDictionary]()
        for index in 0 ..< self.arrOfPhoneContacts.count {
            let dict = self.arrOfPhoneContacts[index] as! NSDictionary
            
            let emailArr = dict.value(forKey: "emailId")! as! Array<Any>
            dictArr.insert(["userName":dict.value(forKey: "userName")!,"emailId": (emailArr[0] as AnyObject).value(forKey: "value")!], at: index)
        }
        //print("Sorted list",dictArr)
        return dictArr
    }
    
    //Delegates
    
    func chooseMyContactsToAddInGroup(cell:AddPeopleMyContactsTableViewCell,sender:UIButton){
        if cell.chooseContactBtn.imageView?.image == UIImage(named: "user.png"){
            
        }
        print("my contacts cell tapped")
    }

    func chooseMyFriendsToAddInGroup(cell:AddPeopleMyFriendsTableViewCell,sender:UIButton){
        print("my freinds cell tapped")
    }

    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1{
            return self.myFriendsListArr.count
           // return (myFriendsListArr[section].value(forKey: "friends") as! [NSDictionary]).count
        }
        else{
            return myContactsListArr.count
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if tableView.tag == 1{
//            return self.myFriendsListArr.count
//        }
//        else{
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView.tag == 1{
//            return 40
//        }
//        else{
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if tableView.tag == 1{
//            return self.myFriendsListArr[section].value(forKey: "letters") as? String
//        }
//        else{
//            return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! AddPeopleMyFriendsTableViewCell
            cell.delegate = self
            let dict = self.myFriendsListArr[indexPath.row]
            
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String
            
            if dict.value(forKey: "state") as! Int == 0{
                cell.chooseFriendBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
            }
            else{
                cell.chooseFriendBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
            }

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
            cell.delegate = self

            let dict = self.myContactsListArr[indexPath.row]
            
            if dict.value(forKey: "state") as! Int == 0{
                cell.chooseContactBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
            }
            else{
                cell.chooseContactBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
            }
            
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            let cell:AddPeopleMyFriendsTableViewCell = self.myFriendsTableView.cellForRow(at: indexPath) as! AddPeopleMyFriendsTableViewCell
            
            if self.myFriendsListArr[indexPath.row].value(forKey: "state") as! Int == 1{
                cell.chooseFriendBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
                self.listOfContactsAddToGroup = self.listOfContactsAddToGroup.filter{$0 != self.myFriendsListArr[indexPath.row].value(forKey: "emailId") as! String}
                self.myFriendsListArr[indexPath.row].setValue(0, forKey: "state")
                print("removed",listOfContactsAddToGroup)
            }
            else{
                cell.chooseFriendBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
                self.listOfContactsAddToGroup.append(self.myFriendsListArr[indexPath.row].value(forKey: "emailId") as! String)
                self.myFriendsListArr[indexPath.row].setValue(1, forKey: "state")
                print("inserted",listOfContactsAddToGroup)
            }
            //print("-------------------",self.myFriendsListArr)
        }
        else{
            let cell:AddPeopleMyContactsTableViewCell = self.myContactsTableView.cellForRow(at: indexPath) as! AddPeopleMyContactsTableViewCell
            if self.myContactsListArr[indexPath.row].value(forKey: "state") as! Int == 1{
                cell.chooseContactBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
                self.listOfContactsAddToGroup = self.listOfContactsAddToGroup.filter{$0 != self.myContactsListArr[indexPath.row].value(forKey: "emailId") as! String}
                self.myContactsListArr[indexPath.row].setValue(0, forKey: "state")
                print("removed",listOfContactsAddToGroup)
            }
            else{
                cell.chooseContactBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
                self.listOfContactsAddToGroup.append(self.myContactsListArr[indexPath.row].value(forKey: "emailId") as! String)
                self.myContactsListArr[indexPath.row].setValue(1, forKey: "state")
                print("inserted",listOfContactsAddToGroup)
            }
            //print("-------------------",self.myFriendsListArr)
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if tableView.tag == 1{
//            let cell:AddPeopleMyFriendsTableViewCell = self.myFriendsTableView.cellForRow(at: indexPath) as! AddPeopleMyFriendsTableViewCell
//            cell.chooseFriendBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
//        }
//        else{
//            let cell:AddPeopleMyContactsTableViewCell = self.myFriendsTableView.cellForRow(at: indexPath) as! AddPeopleMyContactsTableViewCell
//            cell.chooseContactBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
//        }
//    }
    
    //        if tableView.tag == 1{
    //            let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
    //            profileVcObj.profileUserId = self.myFriendsListArr[indexPath.row].value(forKey: "userId") as! String
    //            self.navigationController?.pushViewController(profileVcObj, animated: true)
    //        }
    
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
            
            if self.myContactsListArr.count == 0{
                //get my contacts
                
                let resultArr = self.retreiveEmail()

                var dict = NSMutableDictionary()
                for i in 0..<resultArr.count{
                    dict = resultArr[i].mutableCopy() as! NSMutableDictionary
                    dict.setObject(0, forKey: "state" as NSCopying)
                    self.myContactsListArr.append(dict)
                }
                self.myContactsTableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
