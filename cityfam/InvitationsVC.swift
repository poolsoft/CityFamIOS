//
//  InvitationsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InvitationsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetInvitationsServiceAlamofire {

    //MARK:- Outlets & Properties
    
    @IBOutlet var invitationsTableView: UITableView!
    
    var inviatationsListArr = [NSDictionary]()
    private let invitationsTableRefreshControl = UIRefreshControl()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getInvitationsApi()
        
        // Configure Refresh Control
        invitationsTableRefreshControl.addTarget(self, action: #selector(InvitationsVC.refreshData(sender:)), for: .valueChanged)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- methods
    
    //Pull to refresh Action
    func refreshData(sender:UIRefreshControl){
        self.getInvitationsApi()
    }
    
    //Get Api's Results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
        self.invitationsTableRefreshControl.endRefreshing()
    }
    
    //Get inviations List Api Result
    func getInvitationsResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){

                let resultDict = result.value(forKey: "result") as! NSDictionary
                //invitationCount
                self.inviatationsListArr = resultDict.value(forKey: "eventDetail") as! [NSDictionary]
                self.invitationsTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
            self.invitationsTableRefreshControl.endRefreshing()
        })
    }

    //Get inviations List Api call
    func getInvitationsApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            AlamofireIntegration.sharedInstance.getInvitationsServiceDelegate = self
            AlamofireIntegration.sharedInstance.getInvitationsApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }

    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return inviatationsListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvitationsScreenTableViewCell
        
        let dict = self.inviatationsListArr[indexPath.row]
        
        cell.eventName.text = dict.value(forKey: "eventName") as? String
        cell.noOfPeopleAttendingEventCountLbl.text = dict.value(forKey: "numberOfPeopleAttending") as? String
        
        var eventTimingDetail = ""
        
        if let eventStartTime = dict.value(forKey: "eventStartTime") as? String{
            eventTimingDetail = eventTimingDetail + "Starting from " + eventStartTime
        }
        if let eventAddress = dict.value(forKey: "eventAddress") as? String{
            eventTimingDetail = eventTimingDetail + " at" + eventAddress
        }
        cell.eventTimingDetail.text = eventTimingDetail
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        eventDetailVcObj.eventDetailDict = self.inviatationsListArr[indexPath.row]
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK: UIButton actions
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        profileVcObj.profileUserId = UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }

}
