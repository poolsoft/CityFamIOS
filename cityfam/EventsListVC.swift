//
//  EventsListVC.swift
//  cityfam
//
//  Created by i mark on 10/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventsListVC: UIViewController,GetEventsListOfParticularUserServiceAlamofire {

    //MARK:- Outlets & Properties
    
    var eventsListArr = [NSDictionary]()
    var anotherUserId = String()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Methods
    
    //Get Api's Results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get Events list Result of friends or public
    func getEventsListOfParticularUserResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.eventsListArr = result.value(forKey: "result") as! [NSDictionary]
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //GetEventsList Api call
    func getEventsListOfParticularUserApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            EventsAlamofireIntegration.sharedInstance.getEventsListOfParticularUserServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getEventsListOfParticularUserApi(parameter: anotherUserId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //MARK: UITableView delgates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return eventsListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK:- Button Actions
    
    


}
