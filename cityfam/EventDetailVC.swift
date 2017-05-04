//
//  EventDetailVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import MapKit

class EventDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ChangeStatusOfEventServiceAlamofire,CLLocationManagerDelegate {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var eventTicketLbl: UILabelFontSize!
    @IBOutlet var eventTimeAndAddress: UILabelFontSize!
    @IBOutlet var eventDate: UILabelFontSize!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var userRole: UILabelFontSize!
    @IBOutlet var userName: UILabelFontSize!
    @IBOutlet var userProfileImg: UIImageViewCustomClass!
    @IBOutlet var eventDesclbl: UILabelFontSize!
    @IBOutlet var acceptButton: UIButtonCustomClass!
    @IBOutlet var declineButton: UIButtonCustomClass!
    @IBOutlet var interestedButton: UIButtonCustomClass!
    @IBOutlet var shareEventBtn: UIButtonCustomClass!
    @IBOutlet var editEventBtn: UIButtonCustomClass!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var shareBtnTopConst: NSLayoutConstraint!
    @IBOutlet var ticketsBgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var shareView: UIView!
    
    let typeOfEventsUsersList = [attendingText,invitedText,interestedText,commentsText]
    var eventDetailDict = NSDictionary()
    var eventImagesArray = [String]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shareEventBtn.addTarget(self, action: #selector(EventDetailVC.shareBtnAction), for: .touchUpInside)
        var locationManager:CLLocationManager!
        
        //Map setup
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        
        self.showEventDetail()
        
        //
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.requestAlwaysAuthorization()
    }
    
    //Method to show Event's detail on Screen
    func showEventDetail(){
        //Check Event is created by Login user or another user
        if (self.eventDetailDict.value(forKey: "userId") as! String) == UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!{
            self.editEventBtn.isHidden = false
            self.shareBtnTopConst.constant = 60+self.editEventBtn.bounds.height
        }
        else{
            self.editEventBtn.isHidden = true
            if self.eventDetailDict.value(forKey: "canShareEvent") as! String == "1"{
                self.shareBtnTopConst.constant = 30
            }
            else{
                self.shareEventBtn.isHidden = true
            }
        }
        //event Name, timings and location
        self.eventName.text = self.eventDetailDict.value(forKey: "eventName") as? String
        self.eventDate.text = self.eventDetailDict.value(forKey: "eventStartDate") as? String
        self.eventTimeAndAddress.text = "\(self.eventDetailDict.value(forKey: "eventStartTime") as! String) to \(self.eventDetailDict.value(forKey: "eventEndTime") as! String) at \(self.eventDetailDict.value(forKey: "eventAddress") as! String)"
        
        //Events description
        self.eventDesclbl.text = self.eventDetailDict.value(forKey: "description") as? String
        
        //UserDetail
        if (eventDetailDict.value(forKey: "userImageUrl") as? String) != nil{
            self.userProfileImg.sd_setImage(with: URL(string: (eventDetailDict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
            self.userProfileImg.setShowActivityIndicator(true)
            self.userProfileImg.setIndicatorStyle(.gray)
        }
        else{
            self.userProfileImg.image = UIImage(named: "user.png")
        }
        
        self.userName.text = self.eventDetailDict.value(forKey: "userName") as? String
        self.userRole.text = self.eventDetailDict.value(forKey: "userRole") as? String
        
        self.eventImagesArray = self.eventDetailDict.value(forKey: "eventImagesUrlArray") as! [String]
        
        let latitude = Double((self.eventDetailDict.value(forKey: "latitude") as? String)!)
        let longitude = Double((self.eventDetailDict.value(forKey: "longitude") as? String)!)
        
        //Check selected event has tickets or not
        if (self.eventDetailDict.value(forKey: "ticketLink") as? String) != "" {
            self.ticketsBgViewHeightConstraint.constant = 50.0
            self.eventTicketLbl.text = self.eventDetailDict.value(forKey: "ticketLink") as? String
        }
        else{
            self.ticketsBgViewHeightConstraint.constant = 0.0
        }
        
        //Show eventLocation on Map
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!);
        myAnnotation.title = self.eventDetailDict.value(forKey: "eventAddress") as? String//eventAddress
        mapView.addAnnotation(myAnnotation)
        
        if let myStatus = self.eventDetailDict.value(forKey: "myStatus") as? String{
            switch myStatus {
            case "Accept":
                self.acceptActionPerformedOnEvent()
                break
            case "Interested":
                self.interestedActionPerformedOnEvent()
                break
            case "Decline":
                self.declineActionPerformedOnEvent()
                break
            default:
                self.noActionPerformedOnEvent()
                break
            }
        }
    }
    
    //Api's Methods
    
    //Server failure Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
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
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.eventImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EventDetailImagesCollectionViewCell
        let imageStr = self.eventImagesArray[indexPath.row]
        
        if imageStr != ""{
            cell.eventImg.sd_setImage(with: URL(string: imageStr), placeholderImage: UIImage(named: ""))
            cell.eventImg.setShowActivityIndicator(true)
            cell.eventImg.setIndicatorStyle(.gray)
        }
        else{
            cell.eventImg.image = UIImage(named: "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = (collectionView.frame.size.width)
        let size = CGSize(width: cellWidth, height: collectionView.frame.size.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    //MARK: UITableView Delegates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return typeOfEventsUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventDetailTypeOfUsersTableViewCell
        cell.typeOfPeopleLbl.text = self.typeOfEventsUsersList[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.noOfPeopleCountLbl.text = self.eventDetailDict.value(forKey: "numberOfPeopleAttending") as? String
            break
        case 1:
            cell.noOfPeopleCountLbl.text = self.eventDetailDict.value(forKey: "numberOfPeopleInvited") as? String
            break
        case 2:
            cell.noOfPeopleCountLbl.text = self.eventDetailDict.value(forKey: "numberOfPeopleInterested") as? String
            break
        case 3:
            cell.noOfPeopleCountLbl.text = self.eventDetailDict.value(forKey: "numberOfComments") as? String
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "attendingVc") as! AttendingVC
            secondViewController.eventId = (self.eventDetailDict.value(forKey: "eventId") as? String)!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case 1:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "invitedVc") as! InvitedVC
            secondViewController.eventId = (self.eventDetailDict.value(forKey: "eventId") as? String)!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case 2:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "interestedVc") as! InterestedVC
            secondViewController.eventId = (self.eventDetailDict.value(forKey: "eventId") as? String)!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        case 3:
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentsVc") as! CommentsVC
            self.navigationController?.pushViewController(secondViewController, animated: true)
        default:
            break
        }
    }
    
    //MARK: UIButton Actions
    
    //Back btnAction
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Share with facebook
    @IBAction func facebookBtnAction(_ sender: Any) {
    }
    
    //Share event with friends
    @IBAction func shareBtnAction(_ sender: Any) {
        //        shareView.isHidden = false
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "calenderVc") as! CalenderVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    //Edit this event
    @IBAction func editBtnAction(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "createEventVc") as! CreateEventVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    //Cancel sharing with facebook and google
    @IBAction func cancelButtonAction(_ sender: Any) {
        shareView.isHidden = true
    }
    
    //Share event with google
    @IBAction func googleBtnAction(_ sender: Any) {
    }
    
    //"Accept/ Decline/ Interested" Segement control btn action
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button == acceptButton{
            self.acceptActionPerformedOnEvent()
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Accept")
        }
        else if button == declineButton{
            self.declineActionPerformedOnEvent()
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Decline")
        }
        else{
            self.interestedActionPerformedOnEvent()
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Interested")
        }
    }
    
    //Open Events's Host profile by selecteing his profile image
    @IBAction func openHostProfileBtnAction(_ sender: UIButton) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        profileVcObj.profileUserId = self.eventDetailDict.value(forKey: "userId") as! String
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }
    
    //MARK:- Actions perfomed on events in Freinds tab
    
    //No action is performed on event
    func noActionPerformedOnEvent(){
        interestedButton.isSelected = false
        interestedButton.backgroundColor = UIColor.clear
        acceptButton.isSelected = false
        acceptButton.backgroundColor = UIColor.clear
        declineButton.isSelected = false
        declineButton.backgroundColor = UIColor.clear
    }
    
    //Accept action is performed on event
    func acceptActionPerformedOnEvent(){
        acceptButton.isSelected = true
        acceptButton.backgroundColor = appNavColor
        declineButton.isSelected = false
        declineButton.backgroundColor = UIColor.clear
        interestedButton.isSelected = false
        interestedButton.backgroundColor = UIColor.clear
    }
    
    //Decline action is performed on event
    func declineActionPerformedOnEvent(){
        declineButton.isSelected = true
        declineButton.backgroundColor = appNavColor
        interestedButton.isSelected = false
        interestedButton.backgroundColor = UIColor.clear
        acceptButton.isSelected = false
        acceptButton.backgroundColor = UIColor.clear
    }
    
    //Interested action is performed on event
    func interestedActionPerformedOnEvent(){
        interestedButton.isSelected = true
        interestedButton.backgroundColor = appNavColor
        acceptButton.isSelected = false
        acceptButton.backgroundColor = UIColor.clear
        declineButton.isSelected = false
        declineButton.backgroundColor = UIColor.clear
    }
    
}
