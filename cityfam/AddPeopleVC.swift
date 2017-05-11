//
//  AddPeopleVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class AddPeopleVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GetMyFriendsListServiceAlamofire,MyContactsCellProtocol,MyFriendCellProtocol {
    
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
    var isComingFromProfileScreen = Bool()
    let arrOfPhoneContacts = NSMutableArray()
    
    var listOfContactsAddToGroup = [String]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intial Setup
        selectedSegmentValue = 1
        self.myFriendsTableView.isHidden = false
        self.myContactsTableView.isHidden = true
        
        if isComingFromProfileScreen{
            self.titleLbl.text = "Friends"
        }
        //Get friends list Api call
        self.getMyFriendsListApi()
        self.getMyContacts()
    }
    
    //MARK:- Methods
    
    func sortArrayOfString(arrOfDicts : [NSDictionary])->[String]{
        
        var arr = [String]()
        
        for i in 0..<arrOfDicts.count{
                arr.append(arrOfDicts[i].value(forKey: "userName") as! String)
        }
    
        let b = arr.map{ $0.lowercased() }
        
        let c = b.sorted()
        let d = c.map{ $0[$0.startIndex]}
        
        var dictionary:[String:[String]] = [:]
        _ = d.map{ initial in
            
            let clustered = c.filter{$0.hasPrefix("\(initial)")}
            dictionary.updateValue(clustered, forKey:"\(initial)")
        }
        print("\(dictionary)")
        
        return arr
    }
    
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
    
    func retreiveEmail()->[NSDictionary]{
        var dictArr = [NSDictionary]()
        for index in 0 ..< self.arrOfPhoneContacts.count {
            let dict = self.arrOfPhoneContacts[index] as! NSDictionary
            
            let emailArr = dict.value(forKey: "email")! as! Array<Any>
            dictArr.insert(["name":dict.value(forKey: "name")!,"email": (emailArr[0] as AnyObject).value(forKey: "value")!], at: index)

           // print(dict.value(forKey: "name")!)
           // print(dict.value(forKey: "email")!)
        }
        print("Sorted list",dictArr)
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
            cell.chooseFriendBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)

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
            
            cell.userNameLbl.text = dict.value(forKey: "name") as? String
            cell.chooseContactBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            let cell:AddPeopleMyFriendsTableViewCell = self.myFriendsTableView.cellForRow(at: indexPath) as! AddPeopleMyFriendsTableViewCell
            
            if cell.chooseFriendBtn.imageView?.image == UIImage(named:"tickIcon.png"){
                cell.chooseFriendBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
                self.listOfContactsAddToGroup.append(self.myFriendsListArr[indexPath.row].value(forKey: "emailId") as! String)
                print("inserted",listOfContactsAddToGroup)
            }
            else{
                cell.chooseFriendBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
                
                self.listOfContactsAddToGroup = self.listOfContactsAddToGroup.filter{$0 != self.myFriendsListArr[indexPath.row].value(forKey: "emailId") as! String}
                    print("removed",listOfContactsAddToGroup)
            }
        }
        else{
            let cell:AddPeopleMyContactsTableViewCell = self.myFriendsTableView.cellForRow(at: indexPath) as! AddPeopleMyContactsTableViewCell
            if cell.chooseContactBtn.imageView?.image == UIImage(named:"tickIcon.png"){
                cell.chooseContactBtn.setImage(UIImage(named: "untickIcon.png"), for: UIControlState.normal)
            }
            else{
                cell.chooseContactBtn.setImage(UIImage(named: "tickIcon.png"), for: UIControlState.normal)
            }
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
                myContactsListArr = self.retreiveEmail()
                self.myContactsTableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
//    all contacts:(
//    {
//    email =         (
//    "<CNLabeledValue: 0xb8aa150: identifier=3394DCBF-A9B1-4F2D-A934-3B36C31DE460, label=_$!<Home>!$_, value=test@gmail.com>"
//    );
//    name = "Munish Aggarwal";
//    },
//    {
//    email =         (
//    "<CNLabeledValue: 0xfecd340: identifier=5D0BC8EF-2B2A-4BB7-AF38-BB636D6A2169, label=_$!<Home>!$_, value=developers@imarkinfotech.com>"
//    );
//    name = "Piyush Gupta";
//    },
//    {
//    email =         (
//    "<CNLabeledValue: 0x9f1ad80: identifier=BBE5CBDA-23AF-4BC9-AFDF-4DE5BF513477, label=_$!<Home>!$_, value=developers@imarkinfotech.com>"
//    );
//    name = "Piyush Gupta";
//    }
//    )
//    
    
}
