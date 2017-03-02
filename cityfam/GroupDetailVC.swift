//
//  GroupDetail.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var groupDetailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        groupDetailTableView.tableFooterView = UIView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let addPeopleVcObj = self.storyboard?.instantiateViewController(withIdentifier: "addPeopleVc") as! AddPeopleVC
        self.navigationController?.pushViewController(addPeopleVcObj, animated: true)
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
    }


}
