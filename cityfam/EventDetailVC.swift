//
//  EventDetailVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK:- Outlets & Properties
    
    @IBOutlet var eventTimeAndAddress: UILabelFontSize!
    @IBOutlet var eventDate: UILabelFontSize!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var collectionView: UICollectionView!
   // @IBOutlet var mapView: MKMapView!
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
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return typeOfEventsUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventDetailTypeOfUsersTableViewCell
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
    
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button == acceptButton{
            acceptButton.isSelected = true
            acceptButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            declineButton.isSelected = false
            declineButton.backgroundColor = UIColor.clear
            interestedButton.isSelected = false
            interestedButton.backgroundColor = UIColor.clear
        }
        else if button == declineButton{
            declineButton.isSelected = true
            declineButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            interestedButton.isSelected = false
            interestedButton.backgroundColor = UIColor.clear
            acceptButton.isSelected = false
            acceptButton.backgroundColor = UIColor.clear
        }
        else{
            interestedButton.isSelected = true
            interestedButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            acceptButton.isSelected = false
            acceptButton.backgroundColor = UIColor.clear
            declineButton.isSelected = false
            declineButton.backgroundColor = UIColor.clear
        }
    }


}
