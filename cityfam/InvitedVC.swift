//
//  InvitedVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InvitedVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetListOfPeopleInvitedToTheEventServiceAlamofire {

    //MARK:- Outlets & Properties

    @IBOutlet var bgImgView: UIImageView!
    @IBOutlet var invitedTableView: UITableView!
    var invitedPeopleListArr = [NSDictionary]()
    var eventId = String()
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getListOfPeopleInvitedToTheEventApi()
        //invitedTableView.tableFooterView = UIView()
    }
    
    //MARK:- Methods
    
    
    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //getListOfPeopleAttendingTheEvent Api Result
    func getListOfPeopleInvitedToTheEventResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.invitedPeopleListArr = result.value(forKey: "result") as! [NSDictionary]
                self.invitedTableView.reloadData()
                self.bgImgView.isHidden = true
            }
            else{
                self.bgImgView.isHidden = false
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //getListOfPeopleAttendingTheEvent call
    func getListOfPeopleInvitedToTheEventApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            EventsAlamofireIntegration.sharedInstance.getListOfPeopleInvitedToTheEventServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getListOfPeopleInvitedToTheEventApi(eventId: eventId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }

    //MARK: Button Actions

    //Invirte more friends
    @IBAction func addBtnAction(_ sender: UIButton) {
    }

    //Back button action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return invitedPeopleListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvitedVcTableViewCell
        //emailId = 28;
        //isCityFamUser = 1;

        //accepted/ declined/ interested/ pending
        //"isCityFamUser": "0/1"

        let dict = self.invitedPeopleListArr[indexPath.row]
        
        cell.userNameLbl.text = dict.value(forKey: "userName") as? String
        switch dict.value(forKey: "response") as! String {
        case "accepted":
            cell.userStatusLbl.backgroundColor = UIColor.red
            break
        case "declined":
            cell.userStatusLbl.backgroundColor = UIColor.blue
            break
        case "interested":
            cell.userStatusLbl.backgroundColor = UIColor.black
            break
        case "pending":
            cell.userStatusLbl.backgroundColor = UIColor.yellow
            break
        default:
            break
        }
        
        if (dict.value(forKey: "userImageUrl") as? String) != nil{
            cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: ""))
            cell.userImg.setShowActivityIndicator(true)
            cell.userImg.setIndicatorStyle(.gray)
        }
        else{
            cell.userImg.image = UIImage(named: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
