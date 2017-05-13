//
//  MessagesVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/6/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var publicBtn: UIButtonCustomClass!
    @IBOutlet var privateBtn: UIButtonCustomClass!
    @IBOutlet var friendsBtn: UIButtonCustomClass!
    @IBOutlet var addBtn: UIButtonFontSize!
    @IBOutlet var typeMsgTxtField: UITextFieldCustomClass!
    @IBOutlet var privateView: UIView!
    @IBOutlet var privateTableView: UITableView!
    @IBOutlet var publicView: UIView!
    @IBOutlet var publicTableView: UITableView!
    
    var privateUserChatListArr = [NSDictionary]()
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: UITableView Delgates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4//privateUserChatListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "privateCell", for: indexPath) as! MessageVcPrivateTableViewCell
            
//            let dict = self.privateUserChatListArr[indexPath.row]
//            
//            cell.userNameLbl.text = dict.value(forKey: "userName") as? String
//            
//            if (dict.value(forKey: "userImageUrl") as? String) != nil{
//                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
//                cell.userImg.setShowActivityIndicator(true)
//                cell.userImg.setIndicatorStyle(.gray)
//            }
//            else{
//                cell.userImg.image = UIImage(named: "user.png")
//            }
            return cell
        }
        else{
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! MessageVcPublicTableViewSenderCell
            return senderCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK:- Button Actions
    
    @IBAction func addBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.friendsBtn.isSelected = true
            self.friendsBtn.backgroundColor = appNavColor
            self.privateBtn.isSelected = false
            self.privateBtn.backgroundColor = UIColor.clear
            self.publicBtn.isSelected = false
            self.publicBtn.backgroundColor = UIColor.clear
            break
        case 2:
            self.privateBtn.isSelected = true
            self.privateBtn.backgroundColor = appNavColor
            self.friendsBtn.isSelected = false
            self.friendsBtn.backgroundColor = UIColor.clear
            self.publicBtn.isSelected = false
            self.publicBtn.backgroundColor = UIColor.clear
            self.publicTableView.isHidden = true
            self.privateTableView.isHidden = false
            break
        case 3:
            self.publicBtn.isSelected = true
            self.publicBtn.backgroundColor = appNavColor
            self.privateBtn.isSelected = false
            self.privateBtn.backgroundColor = UIColor.clear
            self.friendsBtn.isSelected = false
            self.friendsBtn.backgroundColor = UIColor.clear
            self.publicTableView.isHidden = false
            self.privateTableView.isHidden = true
            break
        default:
            break
        }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
    }
}
