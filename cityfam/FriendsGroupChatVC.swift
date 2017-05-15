//
//  FriendsGroupChatVC.swift
//  cityfam
//
//  Created by i mark on 15/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class FriendsGroupChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets & Properties
    
    @IBOutlet var friendsChatTableView: UITableView!
    @IBOutlet var typeMsgTxtField: UITextFieldCustomClass!
    
    var friendsChatDetailArr = [NSDictionary]()
    var groupDetailDict = NSDictionary()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4//friendsChatDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! FriendsChatSenderTableViewCell
        return senderCell
    }

    //MARK: Button Actions

    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMembersBtnAction(_ sender: Any) {
        let groupDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "groupDetailVc") as! GroupDetailVC
        groupDetailVcObj.groupDetailDict = self.groupDetailDict
        self.navigationController?.pushViewController(groupDetailVcObj, animated: true)
    }

    @IBAction func sendBtnAction(_ sender: Any) {
    }

}
