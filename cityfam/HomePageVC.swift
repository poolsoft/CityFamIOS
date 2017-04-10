//
//  HomePageVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetEventsListServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var exploreTableView: UITableView!
    @IBOutlet var exploreButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    
    var filtersDataDict = ["distance": "",
                            "categories": "",
                            "daysOfWeek": "",
                            "timeOfDay": ""]
    
    var selectedSegmentValue = Int()
    var eventsListArr = [NSDictionary]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
        
        //adding notification observer to filter events
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "filterEventsNotification"), object:nil, queue:nil, using:catchNotification)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- Methods
    func intialSetup(){
        self.selectedSegmentValue = 0
        getEventsListApi()
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        filtersDataDict = notification.userInfo as! [String : String]
        print(filtersDataDict)
    }

    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get Events list of friends or public
    func getEventsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
                let resultDict = result.value(forKey: "result") as! NSDictionary
                
                self.eventsListArr = resultDict.value(forKey: "eventDetail") as! [NSDictionary]
                //let messageCount = result.value(forKey: "notificationCount") as! String
                
                self.exploreTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    func getEventsListApi() {
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                let parameters = [
                    "userId": UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                    "type": selectedSegmentValue,
                    "filters": self.filtersDataDict
                ] as [String : Any]
                
                EventsAlamofireIntegration.sharedInstance.getEventsListServiceDelegate = self
                EventsAlamofireIntegration.sharedInstance.getEventsListApi(parameters)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomePageTableViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK: UIButton actions

    //UISegment handling for Top menu
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            friendsButton.isSelected = true
            friendsButton.backgroundColor = appNavColor
            exploreButton.isSelected = false
            exploreButton.backgroundColor = UIColor.clear
            exploreTableView.isHidden = true
            selectedSegmentValue = 1
        }
        else{
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            exploreButton.isSelected = true
            exploreButton.backgroundColor = appNavColor
            exploreTableView.isHidden = false
            selectedSegmentValue = 0
        }
    }
    
    //Top bar Filter button Action
    @IBAction func filterButtonAction(_ sender: Any) {
        let filterEventsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "filterEventsVc") as! FilterEventsVC
        self.navigationController?.pushViewController(filterEventsVcObj, animated: true)
    }
    
    //top bar Message Button Action
    @IBAction func notificationButtonAction(_ sender: Any) {
        let notificationsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "notificationsVc") as! NotificationsVC
        self.navigationController?.pushViewController(notificationsVcObj, animated: true)
    }
    
    //Top bar profile button action
    @IBAction func profileButtonAction(_ sender: Any) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }
}
