//
//  NotificationsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var notificationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.tableFooterView = UIView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UIButton actions

    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
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

    
}
