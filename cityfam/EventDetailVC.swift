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
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var eventTimeAndAddress: UILabelFontSize!
    @IBOutlet var eventDate: UILabelFontSize!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var userRole: UILabelFontSize!
    @IBOutlet var userName: UILabelFontSize!
    @IBOutlet var userProfileImg: UIImageViewCustomClass!
    @IBOutlet var eventDesclbl: UILabelFontSize!
    @IBOutlet var ticketsBgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var acceptButton: UIButtonCustomClass!
    @IBOutlet var declineButton: UIButtonCustomClass!
    @IBOutlet var interestedButton: UIButtonCustomClass!
    @IBOutlet var shareView: UIView!
    @IBOutlet var shareEventBtn: UIButtonCustomClass!
    @IBOutlet var editEventBtn: UIButtonCustomClass!
    
    let typeOfEventsUsersList = ["Attending","Invited","Interested","Comments"]
    var eventDetailDict = NSDictionary()
    var eventImagesArray = [String]()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        locationManager.requestAlwaysAuthorization()
    }

    func showEventDetail(){
        if (self.eventDetailDict.value(forKey: "userId") as! String) == UserDefaults.standard.string(forKey: "USER_DEFAULT_userId_Key"){
            self.editEventBtn.isHidden = false
        }
        else{
            self.editEventBtn.isHidden = true
        }
        //event Name, timings and location
        self.eventName.text = self.eventDetailDict.value(forKey: "eventName") as? String
        self.eventDate.text = self.eventDetailDict.value(forKey: "eventStartDate") as? String
        self.eventTimeAndAddress.text = "\(self.eventDetailDict.value(forKey: "eventStartTime") as? String) to \(self.eventDetailDict.value(forKey: "eventEndTime") as? String) at \(self.eventDetailDict.value(forKey: "eventAddress") as? String)"
        
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

//        if let ticketsLink = self.eventDetailDict.value(forKey: "ticketLink"){
//            //self.eve
//        }
        
        //Show eventLocation on Map
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
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
    
    //UIcollection view delagates
    
//    EventDetailImagesCollectionViewCell
    
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
    
    //MARK: UITableView Functions
    
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
    
     //MARK: UIButton actions

    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func facebookBtnAction(_ sender: Any) {
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        shareView.isHidden = false
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        shareView.isHidden = true
    }
    
    @IBAction func googleBtnAction(_ sender: Any) {
    }
    
    //("Accept/ Decline/ Interested")

    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button == acceptButton{
            acceptButton.isSelected = true
            acceptButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            declineButton.isSelected = false
            declineButton.backgroundColor = UIColor.clear
            interestedButton.isSelected = false
            interestedButton.backgroundColor = UIColor.clear
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Accept")
        }
        else if button == declineButton{
            declineButton.isSelected = true
            declineButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            interestedButton.isSelected = false
            interestedButton.backgroundColor = UIColor.clear
            acceptButton.isSelected = false
            acceptButton.backgroundColor = UIColor.clear
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Decline")
        }
        else{
            interestedButton.isSelected = true
            interestedButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            acceptButton.isSelected = false
            acceptButton.backgroundColor = UIColor.clear
            declineButton.isSelected = false
            declineButton.backgroundColor = UIColor.clear
            self.changeStatusOfEventApi(eventId: self.eventDetailDict.value(forKey: "eventId") as! String, status: "Interested")
        }
    }


}
