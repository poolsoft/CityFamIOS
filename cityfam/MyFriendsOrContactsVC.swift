//
//  MyFriendsOrContactsVC.swift
//  cityfam
//
//  Created by i mark on 03/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyFriendsOrContactsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,GetMyFriendsListServiceAlamofire {

    //MARK:- Outlets & Properties
 
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tickBtn: UIButtonFontSize!
    @IBOutlet var titleLbl: UILabelFontSize!
    
    var isComingFromProfileScreen = Bool()
    var searchResultArr = [NSDictionary]()
    var myFriendListArr = [NSDictionary]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tickBtn.isHidden = true
        if isComingFromProfileScreen{
            self.getMyFriendsListApi()
        }
        else{
            self.titleLbl.text = "My Contacts"
            //mycontacts Api
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Methods
    
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
                    self.searchResultArr = resultArr
                    self.tableView.reloadData()
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
    
    //MARK: UITableView delgates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:MyFriendsOrContactsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyFriendsOrContactsTableViewCell
        
        let dict = self.searchResultArr[indexPath.row]

        if isComingFromProfileScreen{
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String
            
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
        }
        else{
            //cell.userNameLbl.text = dict.value(forKey: "name") as? String
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComingFromProfileScreen{
            let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
            profileVcObj.profileUserId = self.searchResultArr[indexPath.row].value(forKey: "userId") as! String
            self.navigationController?.pushViewController(profileVcObj, animated: true)
        }
    }
    
    //MARK:- Button Actions
    
    //Back btn action
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Tick btn action
    
    @IBAction func tickBtnAction(_ sender: Any) {
    
    }
    
    
}
