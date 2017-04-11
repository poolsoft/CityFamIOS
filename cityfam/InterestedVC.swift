//
//  InterestedVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InterestedVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetListOfPeopleInterestedInEventServiceAlamofire {

    //MARK:- Outlets & Properties
    
    @IBOutlet var interestedTableView: UITableView!
    
    var interestedPeopleListArr = [NSDictionary]()
    var eventId = String()
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getListOfPeopleInterestedInEventApi()
        //interestedTableView.tableFooterView = UIView()
    }
    
    //MARK:- Methods
    
    //Api's results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //getListOfPeopleAttendingTheEvent Api Result
    func getListOfPeopleInterestedInEventResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.interestedPeopleListArr = result.value(forKey: "result") as! [NSDictionary]
                self.interestedTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //getListOfPeopleAttendingTheEvent call
    func getListOfPeopleInterestedInEventApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            EventsAlamofireIntegration.sharedInstance.getListOfPeopleInterestedInEventServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getListOfPeopleInterestedInEventApi(eventId: eventId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }

    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return interestedPeopleListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InterestedVcTableViewCell
        
        let dict = self.interestedPeopleListArr[indexPath.row]

        //userId

        cell.userNamelbl.text = dict.value(forKey: "userName") as? String
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
    
    //MARK:- Button Actions
    
    //Back button action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
