//
//  ActivityVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var FriendsActivityButton: UIButtonCustomClass!
    @IBOutlet var myEventsButton: UIButtonCustomClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableView.tableFooterView = UIView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UIButton actions
    
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            FriendsActivityButton.isSelected = true
            FriendsActivityButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            myEventsButton.isSelected = false
            myEventsButton.backgroundColor = UIColor.clear
        }
        else{
            FriendsActivityButton.isSelected = false
            FriendsActivityButton.backgroundColor = UIColor.clear
            myEventsButton.isSelected = true
            myEventsButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
        }
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }


}
