//
//  MyGroupsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyGroupsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MyGroupsVcServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var addNewGroupView: UIView!
    @IBOutlet var myGroupsTableView: UITableView!
    @IBOutlet var enterGroupNameTxtField: UITextFieldCustomClass!
    
    private let myGroupsTableRefreshControl = UIRefreshControl()
    var myGroupsListArr = [NSDictionary]()
    var row = Int()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //myGroupsTableView.tableFooterView = UIView()
        self.getMyGroupsListApi()
        
        if #available(iOS 10.0, *) {
            myGroupsTableView.refreshControl = myGroupsTableRefreshControl
            
        } else {
            myGroupsTableView.addSubview(myGroupsTableRefreshControl)
        }
        
        // Configure Refresh Control
        myGroupsTableRefreshControl.addTarget(self, action: #selector(MyGroupsVC.refreshData(sender:)), for: .valueChanged)
    }
    
    //MARK:- Methods
    
    //Pull to refresh Action
    func refreshData(sender:UIRefreshControl){
        self.getMyGroupsListApi()
    }
    
    //Api's results
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
        self.myGroupsTableRefreshControl.endRefreshing()
    }
    
    //Get My groups Api Result
    func getMyGroupsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.myGroupsListArr = result.value(forKey: "result") as! [NSDictionary]
                self.myGroupsTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
            self.myGroupsTableRefreshControl.endRefreshing()
        })
    }
    
    //Get My groups Api call
    func getMyGroupsListApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.myGroupsVcServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getMyGroupsListApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Create new group Api Result
    func createNewGroupResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                let groupId = result.value(forKey: "result") as? String
                
                let dict = ["groupId":groupId,"groupName":CommonFxns.trimString(string: self.enterGroupNameTxtField.text!),"groupMemberCount":"0"]
                self.myGroupsListArr.append(dict as NSDictionary)
                self.addNewGroupView.isHidden = true
                self.enterGroupNameTxtField.text = ""
                self.myGroupsTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Create new group Api call
    func createNewGroupApi() {
        if self.enterGroupNameTxtField.text != ""{
            
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                
                let parameters = ["userId":UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                                  "groupName":CommonFxns.trimString(string: self.enterGroupNameTxtField.text!)]
                
                FriendsAlamofireIntegration.sharedInstance.myGroupsVcServiceDelegate = self
                FriendsAlamofireIntegration.sharedInstance.createNewGroupApi(parameters: parameters)
                
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
        else{
            CommonFxns.showAlert(self, message: createGroupValidation, title: errorAlertTitle)
        }
    }
    
    //Delete group Api Result
    func deleteGroupApiResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                //Remove group locally
                self.myGroupsListArr.remove(at: self.row)
                self.myGroupsTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Delete group Api call
    func deleteGroupApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            FriendsAlamofireIntegration.sharedInstance.myGroupsVcServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.deleteGroupApi(groupId: self.myGroupsListArr[row].value(forKey: "groupId") as! String)
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
        return self.myGroupsListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:MyGroupsVcTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyGroupsVcTableViewCell
        
        let dict = self.myGroupsListArr[indexPath.row]
        cell.noOfMembersInGroupLbl.text = "(" +  (dict.value(forKey: "groupMemberCount") as? String)! + ")"
        cell.groupNameLbl.text = dict.value(forKey: "groupName") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.row = indexPath.row
        let groupDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "groupDetailVc") as! GroupDetailVC
        groupDetailVcObj.groupDetailDict = self.myGroupsListArr[indexPath.row]
        self.navigationController?.pushViewController(groupDetailVcObj, animated: true)
    }    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        self.row = indexPath.row
        let deleteAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Remove") { (deleteTableViewCellBtnAction, indexPath) in
            self.deleteGroupApi()
        }
        deleteAction.backgroundColor = UIColor.red//UIColor(patternImage: UIImage(named: "user.png")!)
        return [deleteAction]
    }
    
    func deleteTableViewCellBtnAction(){
        print("Delete Button Action")
    }
    
    //MARK:- button Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        addNewGroupView.isHidden = true
        self.enterGroupNameTxtField.text = ""
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        self.createNewGroupApi()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        addNewGroupView.isHidden = false
    }
    
}


//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//            print("delete tableview cell")
//        }
//
//        let ackAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Himanshu", handler: myFunction)
//        ackAction.backgroundColor = UIColor.orangeColor()
//
//        //deleteButton.backgroundColor = UIColor(patternImage: UIImage(named: "delete_button")!)
//    }


//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]{
//
//        let ackAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Himanshu", handler: myFunction)
//        ackAction.backgroundColor = UIColor.orangeColor()
//
//        return [moreAction]
//    }
