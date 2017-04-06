//
//  HomePageVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var exploreTableView: UITableView!
    @IBOutlet var exploreButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //MARK:- Methods
    
    //MARK: UITableView delgates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
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
        }
        else{
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            exploreButton.isSelected = true
            exploreButton.backgroundColor = appNavColor
            exploreTableView.isHidden = false
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
