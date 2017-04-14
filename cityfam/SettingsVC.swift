//
//  SettingsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- outlets & Properties
    
    var settingsArray = ["Connect phone contacts", "Manage notifications", "Invite phone contacts", "Invite facebook friends", "Add events I'm attending to my calendar", "Terms of service"]

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //MARK:- Button Actions
    
    //Back button action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Logout user profile
    @IBAction func logoutButtonAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_userId_Key)
        
       // (UIApplication.sharedApplication().delegate as! AppDelegate).logoutUser()

        //(UIApplication.sharedApplication().delegate as! AppDelegate).
        
        let intialVcObj = self.storyboard?.instantiateViewController(withIdentifier: "logInVC") as! LogInVC
        self.navigationController?.pushViewController(intialVcObj, animated: true)
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabelFontSize
        label.text = settingsArray[indexPath.row]
        let customSwitch = cell.viewWithTag(2) as! UISwitch
        if indexPath.row == 4 {
            customSwitch.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = UIViewController()
        switch indexPath.row {
        case 1:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "manageNotificationsVc") as! ManageNotificationsVC
            self.navigationController?.pushViewController(obj, animated: true)
        case 2:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "inviteFriendsVc") as! InviteFriendsVC
            self.navigationController?.pushViewController(obj, animated: true)
        default:
            break
        }
    }

}
