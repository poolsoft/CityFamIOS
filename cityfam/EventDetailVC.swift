//
//  EventDetailVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var shareView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
     //MARK: UIButton actions

    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        shareView.isHidden = false
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        shareView.isHidden = true
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = UIViewController()
        switch indexPath.row {
        case 0:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "attendingVc") as! AttendingVC
        case 1:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "invitedVc") as! InvitedVC
        case 2:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "interestedVc") as! InterestedVC
        case 3:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "commentsVc") as! CommentsVC
        default:
            break
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }

}
