//
//  MyPlansVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyPlansVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GetUserPlansServiceAlamofire {

    //MARK:- View life cycle

    @IBOutlet var searchTxtField: UITextFieldCustomClass!
    @IBOutlet var upcomingPlansBtn: UIButtonCustomClass!
    @IBOutlet var upcomingPlansTableView: UITableView!
    @IBOutlet var pastPlansTableView: UITableView!
    @IBOutlet var pastPlansBtn: UIButtonCustomClass!
    
    var upcomingPlansListArr = [NSDictionary]()
    var pastPlansListArr = [NSDictionary]()
    var selectedSegmentValue = Int()
    var anotherUserId = String()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserPlansListApi()
        self.selectedSegmentValue = 0
        self.upcomingPlansTableView.isHidden = false
        self.pastPlansTableView.isHidden = true
    }

    //MARK:- Methods
    
    //Api's results
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get Users Plans List Api Result
    func getUserPlansResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
                if self.selectedSegmentValue == 0{
                    self.upcomingPlansListArr = result.value(forKey: "result") as! [NSDictionary]
                    self.upcomingPlansTableView.reloadData()
                }
                else{
                    self.pastPlansListArr = result.value(forKey: "result") as! [NSDictionary]
                    self.pastPlansTableView.reloadData()
                }
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Get Users Plans List Api call
    func getUserPlansListApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            EventsAlamofireIntegration.sharedInstance.getUserPlansServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getUserPlansListApi(anotherUserId: anotherUserId, status: selectedSegmentValue)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1{
            return (upcomingPlansListArr[section].value(forKey: "events") as! [NSDictionary]).count
        }
        else{
            return (pastPlansListArr[section].value(forKey: "events") as! [NSDictionary]).count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1{
            return self.upcomingPlansListArr.count
        }
        else{
            return self.pastPlansListArr.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1{
            return self.upcomingPlansListArr[section].value(forKey: "day") as? String
        }
        else{
            return self.pastPlansListArr[section].value(forKey: "day") as? String
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView.tag == 1{
            let cell:UpcomingPlansTableViewCell = tableView.dequeueReusableCell(withIdentifier: "upcomingPlansCell", for: indexPath) as! UpcomingPlansTableViewCell

            let sectionArr = self.upcomingPlansListArr[indexPath.section].value(forKey: "events") as! [NSDictionary]
            let dict = sectionArr[indexPath.row]
            
            cell.eventNameLbl.text = dict.value(forKey: "eventName") as? String//dict.value(forKey: "eventName") as? String
            cell.eventLocationLbl.text = dict.value(forKey: "eventAddress") as? String
            cell.noOfPeopleAttendingEventLbl.text = dict.value(forKey: "numberOfPeopleAttending") as? String
            
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.hostImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.hostImg.setShowActivityIndicator(true)
                cell.hostImg.setIndicatorStyle(.gray)
            }
            else{
                cell.hostImg.image = UIImage(named: "user.png")
            }
            return cell
        }
        else{
            let cell:PastPlansTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pastPlansCell", for: indexPath) as! PastPlansTableViewCell
            
            let sectionArr = self.pastPlansListArr[indexPath.section].value(forKey: "events") as! [NSDictionary]
            let dict = sectionArr[indexPath.row]
            
            cell.eventNameLbl.text = dict.value(forKey: "eventName") as? String
            cell.eventLocationLbl.text = dict.value(forKey: "eventAddress") as? String
            cell.noOfPeopleAttendingEventLbl.text = dict.value(forKey: "numberOfPeopleAttending") as? String
            
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.hostImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.hostImg.setShowActivityIndicator(true)
                cell.hostImg.setIndicatorStyle(.gray)
            }
            else{
                cell.hostImg.image = UIImage(named: "user.png")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        if tableView.tag == 1{
            let sectionArr = self.upcomingPlansListArr[indexPath.section].value(forKey: "events") as! [NSDictionary]
            eventDetailVcObj.eventDetailDict = sectionArr[indexPath.row]
        }
        else{
            let sectionArr = self.pastPlansListArr[indexPath.section].value(forKey: "events") as! [NSDictionary]
            eventDetailVcObj.eventDetailDict = sectionArr[indexPath.row]
        }
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }

    //MARK:- Button Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlBtnAction(_ sender: UIButton) {
        if sender.tag == 1{
            upcomingPlansBtn.isSelected = true
            upcomingPlansBtn.backgroundColor = appNavColor
            pastPlansBtn.isSelected = false
            pastPlansBtn.backgroundColor = UIColor.clear
            selectedSegmentValue = 0
            self.upcomingPlansTableView.isHidden = false
            self.pastPlansTableView.isHidden = true
            
            if self.upcomingPlansListArr.count == 0{
                self.getUserPlansListApi()
            }
        }
        else{
            upcomingPlansBtn.isSelected = false
            upcomingPlansBtn.backgroundColor = UIColor.clear
            pastPlansBtn.isSelected = true
            pastPlansBtn.backgroundColor = appNavColor
            self.upcomingPlansTableView.isHidden = true
            self.pastPlansTableView.isHidden = false
            selectedSegmentValue = 1
            
            if self.pastPlansListArr.count == 0{
                self.getUserPlansListApi()
            }
        }
    }
}
