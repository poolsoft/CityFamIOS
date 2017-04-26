//
//  FriendVC.swift
//  cityfam
//
//  Created by i mark on 13/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class FriendVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RespondToRequestServiceAlamofire,ManageFriendshipServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var searchTxtField: UITextFieldCustomClass!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var requestTableView: UITableView!
    @IBOutlet var searchButton: UIButtonCustomClass!
    @IBOutlet var requestsButton: UIButtonCustomClass!
    @IBOutlet var searchView: UIView!
    @IBOutlet var requestsView: UIView!
    @IBOutlet var searchBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var searchIconLabel: UILabelFontSize!
    
    var cityFamUserListArr = [NSDictionary]()
    var friendsRequestsListArr = [NSDictionary]()
    var searchedCityFamUsersListArr = [NSDictionary]()
    var selectedBtnTag = Int()
    var selectedRow = Int()
    
    private let refreshControl1 = UIRefreshControl()
    private let refreshControl2 = UIRefreshControl()
    var offSet = 0
    var tempOffset = 1
    var pullToRefresh = false
    
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // searchTableView.tableFooterView = UIView()
        //requestTableView.tableFooterView = UIView()
        
        self.getCityFamUsersApi()
        self.selectedBtnTag = 1
        if #available(iOS 10.0, *) {
            searchTableView.refreshControl = refreshControl1
            requestTableView.refreshControl = refreshControl2

        } else {
            searchTableView.addSubview(refreshControl1)
            requestTableView.addSubview(refreshControl2)
        }
        
        // Configure Refresh Control
        refreshControl2.addTarget(self, action: #selector(FriendVC.refreshData(sender:)), for: .valueChanged)
        refreshControl1.addTarget(self, action: #selector(FriendVC.refreshData(sender:)), for: .valueChanged)

    }

    
    //MARK:- Methods
    
    //Pull to refresh Action
    func refreshData(sender:UIRefreshControl){
        if selectedBtnTag == 1{
            self.offSet = 0
            self.tempOffset = 1
            self.pullToRefresh = true
            self.searchTxtField.text = ""
            self.getCityFamUsersApi()
        }
        else{
            self.getFriendsRequestApi()
        }
    }
    
    func searchText(str:String){
        if str.characters.count == 0{
            searchedCityFamUsersListArr = cityFamUserListArr
            self.searchTableView.reloadData()
        }
        else {
            let resultPredicate = NSPredicate(format: "userName contains[c] %@",str);
            searchedCityFamUsersListArr = cityFamUserListArr.filter { resultPredicate.evaluate(with: $0) };
            self.searchTableView.reloadData()
            print("names = ,\(searchedCityFamUsersListArr)");
        }
    }
    
    //MARK:- TextField Delegates & search methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchText(str: "")
    }
    
    @IBAction func searchTxtFieldEditingChangedAction(_ sender: Any) {
        self.searchText(str: CommonFxns.trimString(string: (sender as AnyObject).text!))
    }
    
    // dismissing keyboard on pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    

    
    //Api's results
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get CityFam user list Api call
    func getCityFamUsersApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.respondToRequestServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getCityFamUsersApi(searchText: "", offset: offSet)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Get CityFam user list Api result
    func getCityFamUsersResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                let arr = result.value(forKey: "result") as! [NSDictionary]
                if self.pullToRefresh{
                    self.cityFamUserListArr  = arr
                    self.searchedCityFamUsersListArr  = arr
                }
                else{
                    self.cityFamUserListArr  = self.cityFamUserListArr + arr
                    self.searchedCityFamUsersListArr  = self.searchedCityFamUsersListArr + arr
                }

                self.searchTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
            self.refreshControl1.endRefreshing()
            self.refreshControl2.endRefreshing()
        })
    }
    
    //Get Freinds request Api call
    func getFriendsRequestApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.respondToRequestServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.getFriendsRequestApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Get Freinds request Api result
    func getFriendsRequestsResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.friendsRequestsListArr = result.value(forKey: "result") as! [NSDictionary]
                self.requestTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
            self.refreshControl1.endRefreshing()
            self.refreshControl2.endRefreshing()
        })
    }
    
    //Respond to request Api call
    func respondToRequestApi(status:Int) {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.respondToRequestServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.respondToRequestApi(anotherUserId: self.friendsRequestsListArr[selectedRow].value(forKey: "userId") as! String, status: status)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Respond to request Api result
    func respondToRequestResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.friendsRequestsListArr.remove(at: self.selectedRow)
                self.requestTableView.reloadData()
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Get CityFam user list Api call
    func manageFriendshipApi(anotherUserId:String) {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            FriendsAlamofireIntegration.sharedInstance.manageFriendshipServiceDelegate = self
            FriendsAlamofireIntegration.sharedInstance.manageFriendshipApi(anotherUserId: anotherUserId, status: 0)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Get CityFam user list Api result
    func manageFriendshipResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                if self.searchedCityFamUsersListArr.count != 0{
                    let dict = self.searchedCityFamUsersListArr[self.selectedRow].mutableCopy() as! NSDictionary
                    dict.setValue("1" as String, forKey: "status")
                    self.searchedCityFamUsersListArr.remove(at: self.selectedRow)
                    self.searchedCityFamUsersListArr.insert(dict, at: self.selectedRow)
                    self.searchTableView.reloadData()
                }
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1 {
            return searchedCityFamUsersListArr.count
        }
        else{
            return friendsRequestsListArr.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchFriendsTableViewCell
            
            let dict = self.searchedCityFamUsersListArr[indexPath.row]
            
            cell.userStatusBtn.addTarget(self, action: #selector(FriendVC.addBtnTapped), for: .touchUpInside)
            cell.userStatusBtn.tag = indexPath.row
            
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String

            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            
            let status = dict.value(forKey: "status") as? String
            switch status! {
            case "0":
                cell.userPendingStatusLbl.text = ""
                cell.userStatusLbl.isHidden = false
                cell.userStatusBtn.isHidden = false

                break
            case "1":
                cell.userPendingStatusLbl.text = "Pending"
                cell.userStatusLbl.isHidden = true
                cell.userStatusBtn.isHidden = true
                break
            default:
                cell.userPendingStatusLbl.text = ""
                cell.userStatusLbl.isHidden = true
                cell.userStatusBtn.isHidden = true
                break
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)as! FriendsRequestTableViewCell

            let dict = self.friendsRequestsListArr[indexPath.row]
            cell.userNameLbl.text = dict.value(forKey: "userName") as? String
            
            if (dict.value(forKey: "userImageUrl") as? String) != nil{
                cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                cell.userImg.setShowActivityIndicator(true)
                cell.userImg.setIndicatorStyle(.gray)
            }
            else{
                cell.userImg.image = UIImage(named: "user.png")
            }
            
            cell.acceptRequestBtn.addTarget(self, action: #selector(FriendVC.acceptBtnTapped), for: .touchUpInside)
            cell.acceptRequestBtn.tag = indexPath.row
            
            cell.declineRequestBtn.addTarget(self, action: #selector(FriendVC.declineBtnTapped), for: .touchUpInside)
            cell.declineRequestBtn.tag = indexPath.row
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //userid
        
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        profileVcObj.profileUserId = self.searchedCityFamUsersListArr[indexPath.row].value(forKey: "userId") as! String
        self.navigationController?.pushViewController(profileVcObj, animated: true)
        
//        if tableView.tag == 1 {
//        }
//        else{
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.searchedCityFamUsersListArr.count - 1
        if indexPath.row == lastElement{
            
            if lastElement == (tempOffset*10-1){
                self.offSet += 1
                self.tempOffset += 1
                self.pullToRefresh = false
                self.getCityFamUsersApi()
            }
        }
    }
    
    //MARK: UIButton actions
    
    
    func addBtnTapped(_ sender : Any) {
        let button = sender as! UIButton
        let tag = button.tag
        selectedRow = tag
        //send request flow
        self.manageFriendshipApi(anotherUserId: self.searchedCityFamUsersListArr[self.selectedRow].value(forKey: "userId") as! String)
    }
    
    func acceptBtnTapped(_ sender : Any) {
        selectedRow = (sender as AnyObject).tag
        self.respondToRequestApi(status: 1)
    }
    
    func declineBtnTapped(_ sender : Any) {
        selectedRow = (sender as AnyObject).tag
        self.respondToRequestApi(status: 0)
    }
    
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            searchButton.isSelected = true
            searchButton.backgroundColor = appNavColor
            requestsButton.isSelected = false
            requestsButton.backgroundColor = UIColor.clear
            searchView.isHidden = false
            requestsView.isHidden = true
            searchBarViewHeightConstraint.constant = 50
            searchIconLabel.isHidden = false
            selectedBtnTag = 1
            if self.cityFamUserListArr.count == 0{
                self.getCityFamUsersApi()
            }
        }
        else{
            searchButton.isSelected = false
            searchButton.backgroundColor = UIColor.clear
            requestsButton.isSelected = true
            requestsButton.backgroundColor = appNavColor
            searchView.isHidden = true
            requestsView.isHidden = false
            searchBarViewHeightConstraint.constant = 0
            searchIconLabel.isHidden = true
            selectedBtnTag = 2
            if self.friendsRequestsListArr.count == 0{
                self.getFriendsRequestApi()
            }
        }
    }
    
    //Go to MyProfile screen
    @IBAction func profileButtonAction(_ sender: Any) {
        let profileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "profileVc") as! ProfileVC
        profileVcObj.profileUserId = UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!
        self.navigationController?.pushViewController(profileVcObj, animated: true)
    }
    
    
}
