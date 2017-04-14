//
//  HomePageVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import SDWebImage

class HomePageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetEventsListServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var exploreTableView: UITableView!
    @IBOutlet var exploreButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    
    private let refreshControl = UIRefreshControl()

    var filtersDataDict = ["distance": "",
                            "categories": "",
                            "daysOfWeek": "",
                            "timeOfDay": ""]
    
    var selectedSegmentValue = Int()
    var eventsListArr = [NSDictionary]()
    
    var friendsEventsListArr = [NSDictionary]()
    var publicEventsListArr = [NSDictionary]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
        
        //adding notification observer to filter events
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "filterEventsNotification"), object:nil, queue:nil, using:catchNotification)
    }

    
    //MARK:- Methods
    
    //IntialSetup Method
    func intialSetup(){
        self.selectedSegmentValue = 0
        self.getEventsListApi()
        
        if #available(iOS 10.0, *) {
            exploreTableView.refreshControl = refreshControl
        } else {
            exploreTableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(HomePageVC.refreshData(sender:)), for: .valueChanged)
    }
    
    //Pull to refresh Action
    func refreshData(sender:UIRefreshControl){
        self.getEventsListApi()
    }

    //Catch filterEventsNotification
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        filtersDataDict = notification.userInfo as! [String : String]
        print(filtersDataDict)
    }

    //Get Api's Results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get Events list Result of friends or public
    func getEventsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
                let resultDict = result.value(forKey: "result") as! NSDictionary
                
                self.eventsListArr = resultDict.value(forKey: "eventDetail") as! [NSDictionary]
                //let messageCount = result.value(forKey: "notificationCount") as! String
                
                if self.selectedSegmentValue == 1{
                    self.friendsEventsListArr = self.eventsListArr
                }
                else{
                    self.publicEventsListArr = self.eventsListArr
                }

                self.exploreTableView.reloadData()
                
                self.refreshControl.endRefreshing()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //GetEventsList Api call
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
        
        let dict = self.eventsListArr[indexPath.row]
        
        cell.eventName.text = dict.value(forKey: "eventName") as? String
        
        var eventTimingDetail = ""
        
        if let eventStartTime = dict.value(forKey: "eventStartTime") as? String{
            eventTimingDetail = eventTimingDetail + "Starting from " + eventStartTime
        }
        if let eventAddress = dict.value(forKey: "eventAddress") as? String{
            eventTimingDetail = eventTimingDetail + " at" + eventAddress
        }
        cell.eventTimingDetail.text = eventTimingDetail
        
        if (dict.value(forKey: "eventCoverImageUrl") as? String) != nil{
            cell.eventCoverImg.sd_setImage(with: URL(string: (dict.value(forKey: "eventCoverImageUrl") as? String)!), placeholderImage: UIImage(named: ""))
            cell.eventCoverImg.setShowActivityIndicator(true)
            cell.eventCoverImg.setIndicatorStyle(.gray)
        }
        else{
            cell.eventCoverImg.image = UIImage(named: "")
        }
        
        if (dict.value(forKey: "userImageUrl") as? String) != nil{
            cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: ""))
            cell.userImg.setShowActivityIndicator(true)
            cell.userImg.setIndicatorStyle(.gray)
        }
        else{
            cell.userImg.image = UIImage(named: "")
        }
        //numberOfPeopleAttending
        return cell
    }
    
//    description = imark;
//    eventAddress = "Event Location";
//    eventCoverImageUrl = "";
//    eventEndDate = "Thursday,April 27,2017";
//    eventEndTime = "06:30 AM";
//    eventId = 68;
//    eventImagesUrlArray =                 (
//    );
//    eventName = "hello party";
//    eventStartDate = "Wednesday,April 26,2017";
//    eventStartTime = "01:30 AM";
//    latitude = "";
//    longitude = "";
//    myStatus = "No Invitation Sent.";
//    numberOfComments = 0;
//    numberOfPeopleAttending = 25;
//    numberOfPeopleInterested = 25;
//    numberOfPeopleInvited = 25;
//    ticketLink = "";
//    userId = 29;
//    userImageUrl = "http://0.gravatar.com/avatar/f9f5a3edac178f9f956b1239d49d2081?s=96&d=mm&r=g";
//    userName = "Z9nh_jai";
//    userRole = "Normal User";
//},
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        eventDetailVcObj.eventDetailDict = self.eventsListArr[indexPath.row]
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
            
            if self.friendsEventsListArr.count == 0{
                self.getEventsListApi()
            }
            else{
                eventsListArr = friendsEventsListArr
                self.exploreTableView.reloadData()
            }
        }
        else{
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            exploreButton.isSelected = true
            exploreButton.backgroundColor = appNavColor
            exploreTableView.isHidden = false
            selectedSegmentValue = 0
            eventsListArr = publicEventsListArr
            self.exploreTableView.reloadData()
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
        profileVcObj.profileUserId = UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }
}
