//
//  AttendingVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class AttendingVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetListOfPeopleAttendingTheEventServiceAlamofire {

    //MARK:- Outlets & Properties
    
    @IBOutlet var bgImgView: UIImageView!
    @IBOutlet var attendingTableView: UITableView!
    
    var eventAttendingPeopleListArr = [NSDictionary]()
    var eventId = String()
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //attendingTableView.tableFooterView = UIView()
        self.getListOfPeopleAttendingTheEventApi()
    }

    //MARK:- Methods

    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //getListOfPeopleAttendingTheEvent Api Result
    func getListOfPeopleAttendingTheEventResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.eventAttendingPeopleListArr = result.value(forKey: "result") as! [NSDictionary]
                self.attendingTableView.reloadData()
                self.bgImgView.isHidden = true
            }
            else{
                self.bgImgView.isHidden = false
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //getListOfPeopleAttendingTheEvent call
    func getListOfPeopleAttendingTheEventApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)

            EventsAlamofireIntegration.sharedInstance.getListOfPeopleAttendingTheEventServiceDelgate = self
            EventsAlamofireIntegration.sharedInstance.getListOfPeopleAttendingTheEventApi(eventId: eventId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }


    //MARK:- Button Actions
    
    //Back button action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return eventAttendingPeopleListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttendingVcTableViewCell
        
        let dict = self.eventAttendingPeopleListArr[indexPath.row]
        //userId
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        profileVcObj.profileUserId = self.eventAttendingPeopleListArr[indexPath.row].value(forKey: "userId") as! String
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }

}
