//
//  HomePageVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var exploreView: UIView!
    @IBOutlet var exploreButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UITableView Functions
    
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

    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            friendsButton.isSelected = true
            friendsButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            exploreButton.isSelected = false
            exploreButton.backgroundColor = UIColor.clear
            exploreView.isHidden = true
        }
        else{
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            exploreButton.isSelected = true
            exploreButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            exploreView.isHidden = false
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        let filterEventsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "filterEventsVc") as! FilterEventsVC
        self.navigationController?.pushViewController(filterEventsVcObj, animated: true)
    }
    
    @IBAction func notificationButtonAction(_ sender: Any) {
        let notificationsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "notificationsVc") as! NotificationsVC
        self.navigationController?.pushViewController(notificationsVcObj, animated: true)
    }
    
}
