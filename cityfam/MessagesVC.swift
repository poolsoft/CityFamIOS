//
//  MessagesVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/6/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetPrivateChatUsersListServiceAlamofire,GetPublicOrFriendsChatServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var publicBtn: UIButtonCustomClass!
    @IBOutlet var privateBtn: UIButtonCustomClass!
    @IBOutlet var friendsBtn: UIButtonCustomClass!
    @IBOutlet var addBtn: UIButtonFontSize!
    @IBOutlet var typeMsgTxtField: UITextFieldCustomClass!
    @IBOutlet var privateView: UIView!
    @IBOutlet var privateTableView: UITableView!
    @IBOutlet var publicView: UIView!
    @IBOutlet var publicTableView: UITableView!
    
    var privateUserChatListArr = [NSDictionary]()
    var publicChatListArr = [NSDictionary]()

    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privateTableView.tableFooterView = UIView()
        //publicTableView.tableFooterView = UIView()

        //TableView dynamic row setup
        self.publicTableView.estimatedRowHeight = 70
        self.publicTableView.rowHeight = UITableViewAutomaticDimension
        
        //Set intial setup to private chat
        self.privateMenuBtnTapped()
        self.getPrivateChatUsersListApi()
    }
    
    //MARK:- Methods
    
    //Api's results
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //GetPrivateUserChat Api Result
    func getPrivateChatUsersListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.privateUserChatListArr = result.value(forKey: "result") as! [NSDictionary]
                self.privateTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //GetPrivateUserChat Api call
    func getPrivateChatUsersListApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.getPrivateChatUsersListServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getPrivateChatUsersListApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }

    //getPublicOrFriendsChat Api Result
    func getPublicOrFriendsChatResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.publicChatListArr = result.value(forKey: "result") as! [NSDictionary]
                self.publicTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //getPublicOrFriendsChat Api call
    func getPublicOrFriendsChatApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.getPublicOrFriendsChatServiceDelgate = self
            FriendsAlamofireIntegration.sharedInstance.getPublicOrFriendsChatApi(type: "2")
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1{
            return privateUserChatListArr.count
        }
        else{
            return publicChatListArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "privateCell", for: indexPath) as! MessageVcPrivateTableViewCell

        let dict = self.privateUserChatListArr[indexPath.row]
            
            cell.userNameLbl.text = dict.value(forKey: "chatUserName") as? String
            cell.msgTimeLbl.text = dict.value(forKey: "timeElapsed") as? String
            cell.unreadMsgCountLbl.text = dict.value(forKey: "unReadMessagesCount") as? String
            cell.msgLbl.text = dict.value(forKey: "chatMessage") as? String
            
            if (dict.value(forKey: "chatUserImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "chatUserImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            return cell
        }
        else{
            let dict = self.publicChatListArr[indexPath.row]
            
            if dict.value(forKey: "chatUserId") as! String == UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!{
                let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! MessageVcPublicTableViewSenderCell
                
                
                if (dict.value(forKey: "chatUserImageUrl") as? String) != nil{
                    senderCell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "chatUserImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                    senderCell.userImg.setShowActivityIndicator(true)
                    senderCell.userImg.setIndicatorStyle(.gray)
                }
                else{
                    senderCell.userImg.image = UIImage(named: "user.png")
                }
                senderCell.msgLbl.text = dict.value(forKey: "chatMessage") as? String
                return senderCell
            }
            else{
                let receiverCell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as! MessageVcPublicTableViewReceiverCell
                
                if (dict.value(forKey: "chatUserImageUrl") as? String) != nil{
                    receiverCell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "chatUserImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                    receiverCell.userImg.setShowActivityIndicator(true)
                    receiverCell.userImg.setIndicatorStyle(.gray)
                }
                else{
                    receiverCell.userImg.image = UIImage(named: "user.png")
                }
                receiverCell.msgLbl.text = dict.value(forKey: "chatMessage") as? String
                return receiverCell
            }

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendsGroupChatVcObj = self.storyboard?.instantiateViewController(withIdentifier: "friendsGroupChatVc") as! FriendsGroupChatVC
        //friendsGroupChatVcObj.groupDetailDict = self.myGroupsListArr[indexPath.row]
        self.navigationController?.pushViewController(friendsGroupChatVcObj, animated: true)
    }
    
    //MARK:- Button Actions
    
    @IBAction func addBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
//            self.friendsBtn.isSelected = true
//            self.friendsBtn.backgroundColor = appNavColor
//            self.privateBtn.isSelected = false
//            self.privateBtn.backgroundColor = UIColor.clear
//            self.publicBtn.isSelected = false
//            self.publicBtn.backgroundColor = UIColor.clear
            let myGroupVcObj = self.storyboard?.instantiateViewController(withIdentifier: "myGroupsVc") as! MyGroupsVC
            myGroupVcObj.isComingFromMyProfileVc = "1"
            self.navigationController?.pushViewController(myGroupVcObj, animated: true)
            break
        case 2:
            self.privateMenuBtnTapped()
            break
        case 3:
            self.publicBtn.isSelected = true
            self.publicBtn.backgroundColor = appNavColor
            self.privateBtn.isSelected = false
            self.privateBtn.backgroundColor = UIColor.clear
            self.friendsBtn.isSelected = false
            self.friendsBtn.backgroundColor = UIColor.clear
            self.publicView.isHidden = false
            self.privateView.isHidden = true
            
            if self.publicChatListArr.count == 0{
                self.getPublicOrFriendsChatApi()
            }
            break
        default:
            break
        }
    }
    
    func privateMenuBtnTapped(){
        self.privateBtn.isSelected = true
        self.privateBtn.backgroundColor = appNavColor
        self.friendsBtn.isSelected = false
        self.friendsBtn.backgroundColor = UIColor.clear
        self.publicBtn.isSelected = false
        self.publicBtn.backgroundColor = UIColor.clear
        self.publicView.isHidden = true
        self.privateView.isHidden = false
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
    }
}
