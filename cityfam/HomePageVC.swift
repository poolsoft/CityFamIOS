//
//  HomePageVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import SDWebImage
import EventKit

class HomePageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GetEventsListServiceAlamofire,ChangeStatusOfEventServiceAlamofire,HomeFriendsTableViewCellProtocol,HomePageTableViewCellProtocol {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var friendsTableView: UITableView!
    @IBOutlet var exploreTableView: UITableView!
    @IBOutlet var exploreButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    
    private let friendsTableRefreshControl = UIRefreshControl()
    private let exploreTableRefreshControl = UIRefreshControl()
    var filtersDataDict = ["distance": "",
                            "categories": "",
                            "daysOfWeek": "",
                            "timeOfDay": ""]
    var selectedSegmentValue = Int()
    //var eventsListArr = [NSDictionary]()
    var friendsEventsListArr = [NSDictionary]()
    var publicEventsListArr = [NSDictionary]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
        
        let abcStr = abc()
        
        print(abcStr as Any)
    
        //adding notification observer to filter events
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: "filterEventsNotification"), object:nil, queue:nil, using:catchNotification)
        
        //adding notification observer to update events
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageVC.catchUpdateEventsNotification), name: NSNotification.Name(rawValue: "updateEventsNotification"), object: nil)
    }

    func abc()->String?{
        let str = ""
        return str
    }
    
    //MARK:- Methods
    
    func setEventInDeviceCalender(){
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
        
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
        
                let event:EKEvent = EKEvent(eventStore: eventStore)
        
                event.title = "Reminder CityFam, Alert"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY mm dd - hh:mm"
                
                //let startDate = dateFormatter.date(from: "2017 04 22 - 12:29")
                //let endDate = dateFormatter.date(from: "2017 04 22 - 12:30")
                event.startDate = Date()
                event.endDate = Date()
                
               // print("start date: ", startDate!, "end date: ", endDate!)
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
    
    //IntialSetup Method
    func intialSetup(){
        self.selectedSegmentValue = 0
        self.getEventsListApi()
        
        if #available(iOS 10.0, *) {
            friendsTableView.refreshControl = friendsTableRefreshControl
            exploreTableView.refreshControl = exploreTableRefreshControl

        } else {
            friendsTableView.addSubview(friendsTableRefreshControl)
            exploreTableView.addSubview(exploreTableRefreshControl)
        }
        self.friendsTableView.isHidden = true
        self.exploreTableView.isHidden = false
        
        // Configure Refresh Control
        friendsTableRefreshControl.addTarget(self, action: #selector(HomePageVC.refreshData(sender:)), for: .valueChanged)
        exploreTableRefreshControl.addTarget(self, action: #selector(HomePageVC.refreshData(sender:)), for: .valueChanged)
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

    //Catch updateEventsNotification
    func catchUpdateEventsNotification(){
        
    }
    
    //Get Api's Results
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
        self.friendsTableRefreshControl.endRefreshing()
        self.exploreTableRefreshControl.endRefreshing()
    }
    
    //Get Events list Result of friends or public
    func getEventsListResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
                let resultDict = result.value(forKey: "result") as! NSDictionary
                
                let eventsListArr = resultDict.value(forKey: "eventDetail") as! [NSDictionary]
                //let messageCount = result.value(forKey: "notificationCount") as! String
                
                if self.selectedSegmentValue == 1{
                    self.friendsEventsListArr = eventsListArr
                    self.friendsTableView.reloadData()
                }
                else{
                    self.publicEventsListArr = eventsListArr
                    self.exploreTableView.reloadData()
                }
            }
            else{
                if self.selectedSegmentValue == 1{
                    self.friendsEventsListArr.removeAll()
                    self.friendsTableView.reloadData()
                }
                else{
                    self.publicEventsListArr.removeAll()
                    self.exploreTableView.reloadData()
                }
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
            self.friendsTableRefreshControl.endRefreshing()
            self.exploreTableRefreshControl.endRefreshing()
        })
    }
    
    //ChangeStatusOfEvent Api call
    func changeStatusOfEventApi(eventId:String, status:String) {
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                EventsAlamofireIntegration.sharedInstance.changeStatusOfEventServiceDelegate = self
                EventsAlamofireIntegration.sharedInstance.changeStatusOfEventApi(eventId:eventId, status:status)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
    }
    
    //ChangeStatusOfEvent Api Result
    func changeStatusOfEventResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.getEventsListApi()
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
        if tableView.tag == 1{
            return friendsEventsListArr.count
        }
        else{
            return publicEventsListArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1{
            let cell:HomeFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! HomeFriendsTableViewCell
            cell.delegate = self
            let dict = self.friendsEventsListArr[indexPath.row]
            cell.eventName.text = dict.value(forKey: "eventName") as? String
            cell.noOfPeopleAttendingEventCountLbl.text = dict.value(forKey: "numberOfPeopleAttending") as? String
            var eventTimingDetail = ""
            if let eventStartTime = dict.value(forKey: "eventStartTime") as? String{
                eventTimingDetail = eventTimingDetail + "Starting from " + eventStartTime
            }
            if let eventAddress = dict.value(forKey: "eventAddress") as? String{
                eventTimingDetail = eventTimingDetail + " at " + eventAddress
            }
            cell.eventTimingDetail.text = eventTimingDetail
            
            if (dict.value(forKey: "eventCoverImageUrl") as? String) != nil{
                cell.eventCoverImg.sd_setImage(with: URL(string: (dict.value(forKey: "eventCoverImageUrl") as? String)!), placeholderImage: UIImage(named: "homePic.png"))
                cell.eventCoverImg.setShowActivityIndicator(true)
                cell.eventCoverImg.setIndicatorStyle(.gray)
            }
            else{
                cell.eventCoverImg.image = UIImage(named: "homePic.png")
            }
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            if let myStatus = dict.value(forKey: "myStatus") as? String{
                switch myStatus {
                case "Accept":
                    self.acceptActionPerformedOnEvent(cell: cell)
                    break
                case "Interested":
                    self.interestedActionPerformedOnEvent(cell: cell)
                    break
                case "Decline":
                    self.declineActionPerformedOnEvent(cell: cell)
                    break
                default:
                    self.noActionPerformedOnEvent(cell: cell)
                    break
                }
            }
            return cell
        }
        else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! HomePageTableViewCell
            cell.delegate = self
            let dict = self.publicEventsListArr[indexPath.row]
            cell.eventName.text = dict.value(forKey: "eventName") as? String
            cell.noOfPeopleAttendingEventCountLbl.text = dict.value(forKey: "numberOfPeopleAttending") as? String
            var eventTimingDetail = ""
            if let eventStartTime = dict.value(forKey: "eventStartTime") as? String{
                eventTimingDetail = eventTimingDetail + "Starting from " + eventStartTime
            }
            if let eventAddress = dict.value(forKey: "eventAddress") as? String{
                eventTimingDetail = eventTimingDetail + " at " + eventAddress
            }
            cell.eventTimingDetail.text = eventTimingDetail
            
            if (dict.value(forKey: "eventCoverImageUrl") as? String) != nil{
                cell.eventCoverImg.sd_setImage(with: URL(string: (dict.value(forKey: "eventCoverImageUrl") as? String)!), placeholderImage: UIImage(named: "homePic.png"))
                cell.eventCoverImg.setShowActivityIndicator(true)
                cell.eventCoverImg.setIndicatorStyle(.gray)
            }
            else{
                cell.eventCoverImg.image = UIImage(named: "homePic.png")
            }
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            
            if let myStatus = dict.value(forKey: "myStatus") as? String{
                switch myStatus {
                case "Accept":
                    self.onExploreEventAcceptActionPerformed(cell: cell)
                    break
                case "Interested":
                    self.onExploreEventInterestedActionPerformed(cell: cell)
                    break
                case "Decline":
                    self.onExploreEventDeclineActionPerformed(cell: cell)
                    break
                default:
                    self.onExploreEventNoActionPerformed(cell: cell)
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        if tableView.tag == 1{
            eventDetailVcObj.eventDetailDict = self.friendsEventsListArr[indexPath.row]
        }
        else{
            eventDetailVcObj.eventDetailDict = self.publicEventsListArr[indexPath.row]
        }
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK: UIButton actions

    //Change Status for friends's Events
    func friendsTabChangeStatusOfEventSegmentControl(cell: HomeFriendsTableViewCell,sender:UIButton){
        
        let row = self.friendsTableView.indexPath(for: cell)?.row
        if sender.tag == 1{
            self.acceptActionPerformedOnEvent(cell: cell)
            self.changeStatusOfEventApi(eventId: self.friendsEventsListArr[row!].value(forKey: "eventId") as! String, status: "Accept")
        }
        else if sender.tag == 2{
            self.declineActionPerformedOnEvent(cell: cell)
            self.changeStatusOfEventApi(eventId: self.friendsEventsListArr[row!].value(forKey: "eventId") as! String, status: "Decline")
        }
        else{
            self.interestedActionPerformedOnEvent(cell: cell)
            self.changeStatusOfEventApi(eventId: self.friendsEventsListArr[row!].value(forKey: "eventId") as! String, status: "Interested")
        }
    }
    
    // Actions perfomed on events in Freinds tab
    
    //No action is performed on event
    func noActionPerformedOnEvent(cell: HomeFriendsTableViewCell){
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
    }
    
    //Accept action is performed on event
    func acceptActionPerformedOnEvent(cell: HomeFriendsTableViewCell){
        cell.acceptBtn.isSelected = true
        cell.acceptBtn.backgroundColor = appNavColor
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
    }
    
    //Decline action is performed on event
    func declineActionPerformedOnEvent(cell: HomeFriendsTableViewCell){
        cell.declineBtn.isSelected = true
        cell.declineBtn.backgroundColor = appNavColor
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
    }
    
    //Interested action is performed on event
    func interestedActionPerformedOnEvent(cell: HomeFriendsTableViewCell){
        cell.interestedBtn.isSelected = true
        cell.interestedBtn.backgroundColor = appNavColor
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
    }
    
    // Actions perfomed on event in Explore tab
    //No action is performed on event
    func onExploreEventNoActionPerformed(cell: HomePageTableViewCell){
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
    }
    
    //Accept action is performed on event
    func onExploreEventAcceptActionPerformed(cell: HomePageTableViewCell){
        cell.acceptBtn.isSelected = true
        cell.acceptBtn.backgroundColor = appNavColor
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
    }
    
    //Decline action is performed on event
    func onExploreEventDeclineActionPerformed(cell: HomePageTableViewCell){
        cell.declineBtn.isSelected = true
        cell.declineBtn.backgroundColor = appNavColor
        cell.interestedBtn.isSelected = false
        cell.interestedBtn.backgroundColor = UIColor.clear
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
    }
    
    //Interested action is performed on event
    func onExploreEventInterestedActionPerformed(cell: HomePageTableViewCell){
        cell.interestedBtn.isSelected = true
        cell.interestedBtn.backgroundColor = appNavColor
        cell.acceptBtn.isSelected = false
        cell.acceptBtn.backgroundColor = UIColor.clear
        cell.declineBtn.isSelected = false
        cell.declineBtn.backgroundColor = UIColor.clear
    }
    
    //Change Status for public Events
    func exploreTabChangeStatusOfEventSegmentControl(cell: HomePageTableViewCell,sender:UIButton){
        
        let row = self.exploreTableView.indexPath(for: cell)?.row
        if sender.tag == 1{
            self.onExploreEventAcceptActionPerformed(cell: cell)
            self.changeStatusOfEventApi(eventId: self.publicEventsListArr[row!].value(forKey: "eventId") as! String, status: "Accept")
        }
        else if sender.tag == 2{
            self.onExploreEventDeclineActionPerformed(cell: cell)
            self.changeStatusOfEventApi(eventId: self.publicEventsListArr[row!].value(forKey: "eventId") as! String, status: "Decline")
        }
        else{
            self.onExploreEventInterestedActionPerformed(cell: cell)
            self.changeStatusOfEventApi(eventId: self.publicEventsListArr[row!].value(forKey: "eventId") as! String, status: "Interested")
        }
    }
    
    //UISegment handling for Top menu
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            friendsButton.isSelected = true
            friendsButton.backgroundColor = appNavColor
            exploreButton.isSelected = false
            exploreButton.backgroundColor = UIColor.clear
            selectedSegmentValue = 1
            self.friendsTableView.isHidden = false
            self.exploreTableView.isHidden = true

            if self.friendsEventsListArr.count == 0{
                self.getEventsListApi()
            }
        }
        else{
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            exploreButton.isSelected = true
            exploreButton.backgroundColor = appNavColor
            self.friendsTableView.isHidden = true
            self.exploreTableView.isHidden = false
            selectedSegmentValue = 0
        }
    }
    
    //Top bar Filter button Action
    //Go to filter screen
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
