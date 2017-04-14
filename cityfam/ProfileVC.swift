//
//  ProfileVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GetUserProfileServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var userNameLbl: UILabelFontSize!
    @IBOutlet var userLocationLbl: UILabelFontSize!
    @IBOutlet var photosBgView: UIViewCustomClass!
    @IBOutlet var seeAllPhotosBtn: UIButtonCustomClass!
    @IBOutlet var addBtn: UIButtonCustomClass!
    @IBOutlet var editBtn: UIButtonFontSize!
    @IBOutlet var addPhotosBtn: UIButtonCustomClass!
    @IBOutlet var manageConnectionBtn: UIButtonCustomClass!
    @IBOutlet var tableView: UITableView!
    
    var profileUserId = String()
    var profileTableViewArray = ["My Groups", "My Plans", "My Friends"]
    var imagesArray = ["user","user","user","user"]

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notMyFriendProfileLayoutSetup()
        manageConnectionBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        
        self.getUserProfileApi()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- Methods
    
    func myFriendProfileLayoutSetup(){
        self.userLocationLbl.isHidden = false
        self.photosBgView.isHidden = false
        self.tableView.isHidden = false
        self.manageConnectionBtn.isHidden = false
        self.addBtn.isHidden = true
    }
    
    func notMyFriendProfileLayoutSetup(){
        self.userLocationLbl.isHidden = true
        self.photosBgView.isHidden = true
        self.tableView.isHidden = true
        self.manageConnectionBtn.isHidden = true
        self.addBtn.isHidden = false
    }
    
    func myProfileLayoutSetup(){
        self.userLocationLbl.isHidden = false
        self.photosBgView.isHidden = false
        self.tableView.isHidden = false
        self.manageConnectionBtn.isHidden = true
        self.addBtn.isHidden = true
    }
    
    
    //Api's results
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get CityFam user list Api call
    func getUserProfileApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            AlamofireIntegration.sharedInstance.getUserProfileServiceDelegate = self
            AlamofireIntegration.sharedInstance.getUserProfileApi(anotherUserId:profileUserId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Get CityFam user list Api result
    func getUserProfileResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
                let dict = result.value(forKey: "result") as! NSDictionary
                
                if (dict.value(forKey: "userImageUrl") as? String) != nil{
                    self.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                    self.userImg.setShowActivityIndicator(true)
                    self.userImg.setIndicatorStyle(.gray)
                }
                else{
                    self.userImg.image = UIImage(named: "user.png")
                }
                
                self.userNameLbl.text = dict.value(forKey: "userName") as? String
                
                    switch (dict.value(forKey: "isMyFriend") as! Int){
                    case 0:
                        if self.profileUserId == UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key){
                            self.myProfileLayoutSetup()
                        }
                        else{
                            self.notMyFriendProfileLayoutSetup()
                        }
                        self.userLocationLbl.text = dict.value(forKey: "userAddress") as? String

                        break
                    case 1:
                        self.myFriendProfileLayoutSetup()
                        break
                    default:
                        break
                    }

//                {
//                    error = "No Error Found.";
//                    result =     {
//                        isMyFriend = 0;
//                        userAddress = panna;
//                        userId = 6;
//                        userImageUrl = "";
//                        userImagesArray =         (
//                        );
//                        userName = ahbsh;
//                    };
//                    success = 1;
//                }
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }

    //MARK: UITableView Delagtes & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return profileTableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabelFontSize
        label.text = profileTableViewArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = UIViewController()
        switch indexPath.row {
        case 0:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myGroupsVc") as! MyGroupsVC
        case 1:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myPlansVc") as! MyPlansVC
        case 2:
            obj = self.storyboard?.instantiateViewController(withIdentifier: "myPlansVc") as! MyPlansVC
        default:
            break
        }
        self.navigationController?.pushViewController(obj, animated: true)

    }
    
    //MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: imagesArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = (collectionView.frame.size.width-30)/4
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }

    
    //MARK:- View life cycle

    
    @IBAction func backBtnAction(_ sender: UIButton) {
    }
    
    func unfriendBtnAction(sender:UIButton){
    }

    func editBtnAction(sender:UIButton){
    }
    
    func addBtnAction(sender:UIButton){
    }
    

}
