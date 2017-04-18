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
            
            if self.myContactsListArr.count == 0{
                //get my contacts
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
