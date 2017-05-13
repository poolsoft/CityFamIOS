//
//  GroupDetail.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GroupDetailVcServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var titleLbl: UILabelFontSize!
    @IBOutlet var groupDetailTableView: UITableView!

    var membersListOfSelectedGroupArr = [NSDictionary]()
    var groupDetailDict = NSDictionary()
    var row = Int()

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // groupDetailTableView.tableFooterView = UIView()
        self.getMembersOfGroupApi()
        
        self.titleLbl.text = self.groupDetailDict.value(forKey: "groupName") as? String
        
        //adding notification observer to update events
        NotificationCenter.default.addObserver(self, selector: #selector(GroupDetailVC.updateGroupDetailNotification), name: NSNotification.Name(rawValue: "updateGroupDetailNotification"), object: nil)
    }

    //MARK:- Methods
    
    //Catch notification of Update Group Detail
    func updateGroupDetailNotification(){
        self.getMembersOfGroupApi()
    }
    
    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get My groups Api Result
    func getMembersOfGroupResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.membersListOfSelectedGroupArr = result.value(forKey: "result") as! [NSDictionary]
                self.groupDetailTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Get My groups Api call
    func getMembersOfGroupApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.groupDetailVcServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getMembersOfGroupApi(groupId:self.groupDetailDict.value(forKey: "groupId") as! String)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
 
    //Delete member of group Api Result
    func deleteMemberOfGroupResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                //Remove group member locally
                self.membersListOfSelectedGroupArr.remove(at: self.row)
                self.groupDetailTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Delete member of group Api call
    func deleteMemberOfGroupApi(emailId:String) {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.groupDetailVcServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.deleteMemberOfGroupApi(groupId: self.groupDetailDict.value(forKey: "groupId") as! String, emailId: "")
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return membersListOfSelectedGroupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:GroupDetailVcTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupDetailVcTableViewCell
        
        let dict = self.membersListOfSelectedGroupArr[indexPath.row]
        cell.groupMemberNameLbl.text = dict.value(forKey: "userName") as? String
        
        if (dict.value(forKey: "userImageUrl") as? String) != nil{
            cell.groupMemberProfileImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
            cell.groupMemberProfileImg.setShowActivityIndicator(true)
            cell.groupMemberProfileImg.setIndicatorStyle(.gray)
        }
        else{
            cell.groupMemberProfileImg.image = UIImage(named: "user.png")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        self.row = indexPath.row
        let deleteAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Remove") { (deleteTableViewCellBtnAction, indexPath) in
            self.deleteMemberOfGroupApi(emailId:self.membersListOfSelectedGroupArr[indexPath.row].value(forKey: "emailId") as! String)
        }
        deleteAction.backgroundColor = UIColor.red//UIColor(patternImage: UIImage(named: "user.png")!)
        return [deleteAction]
    }
    
    func deleteTableViewCellBtnAction(){
    }
    
    //MARK:- Back btn action
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let addPeopleVcObj = self.storyboard?.instantiateViewController(withIdentifier: "addPeopleVc") as! AddPeopleVC
        addPeopleVcObj.groupId = self.groupDetailDict.value(forKey: "groupId") as! String
        self.navigationController?.pushViewController(addPeopleVcObj, animated: true)
    }

}
