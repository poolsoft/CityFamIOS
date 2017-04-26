//
//  ProfileVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GetUserProfileServiceAlamofire,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddPhototoToProfileServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var settingsBtn: UIButtonFontSize!
    @IBOutlet var editBtnHeightConstraint: NSLayoutConstraint!

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
    var imagesArray = NSArray()
    var profileInfoDict = NSDictionary()
    
    let imagePicker = UIImagePickerController()
    var userPhotosToUpload:UIImage!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notMyFriendProfileLayoutSetup()
        imagePicker.delegate = self

//        manageConnectionBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
//        editBtn.addTarget(self, action: #selector(ProfileVC.editBtnAction(sender:)), for: .touchUpInside)
//        addBtn.addTarget(self, action: #selector(ProfileVC.addBtnAction(sender:)), for: .touchUpInside)
//        seeAllPhotosBtn.addTarget(self, action: #selector(ProfileVC.editBtnAction(sender:)), for: .touchUpInside)
//        addBtn.addTarget(self, action: #selector(ProfileVC.addBtnAction(sender:)), for: .touchUpInside)
//        manageConnectionBtn.addTarget(self, action: #selector(ProfileVC.unfriendBtnAction(sender:)), for: .touchUpInside)
        
        //adding notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.updateProfileNotification), name: NSNotification.Name(rawValue: "updateProfileInfoNotification"), object: nil)
        
        self.getUserProfileApi()
    }

    
    //MARK:- Methods
    
    func updateProfileNotification(){
        self.getUserProfileApi()
    }
    
    func myFriendProfileLayoutSetup(){
        self.userLocationLbl.isHidden = false
        self.photosBgView.isHidden = false
        self.tableView.isHidden = false
        self.manageConnectionBtn.isHidden = false
        self.addBtn.isHidden = true
        self.editBtn.isHidden = true
        self.editBtnHeightConstraint.constant = 0.0
        self.settingsBtn.isHidden = true
    }
    
    func notMyFriendProfileLayoutSetup(){
        self.userLocationLbl.isHidden = true
        self.photosBgView.isHidden = true
        self.tableView.isHidden = true
        self.manageConnectionBtn.isHidden = true
        self.addBtn.isHidden = false
        self.editBtn.isHidden = true
        self.editBtnHeightConstraint.constant = 0.0
        self.settingsBtn.isHidden = true
    }
    
    func myProfileLayoutSetup(){
        self.userLocationLbl.isHidden = false
        self.photosBgView.isHidden = false
        self.tableView.isHidden = false
        self.manageConnectionBtn.isHidden = true
        self.addBtn.isHidden = true
        self.editBtn.isHidden = false
        self.editBtnHeightConstraint.constant = 30.0
        self.settingsBtn.isHidden = false
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
                
                self.profileInfoDict = result.value(forKey: "result") as! NSDictionary
                
                if (self.profileInfoDict.value(forKey: "userImageUrl") as? String) != nil{
                    self.userImg.sd_setImage(with: URL(string: (self.profileInfoDict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
                    self.userImg.setShowActivityIndicator(true)
                    self.userImg.setIndicatorStyle(.gray)
                }
                else{
                    self.userImg.image = UIImage(named: "user.png")
                }
                
                self.imagesArray = self.profileInfoDict.value(forKey: "userImagesArray") as! NSArray
                
                self.userNameLbl.text = self.profileInfoDict.value(forKey: "userName") as? String
                
                    switch (self.profileInfoDict.value(forKey: "isMyFriend") as! Int){
                    case 0:
                        if self.profileUserId == UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key){
                            self.myProfileLayoutSetup()
                        }
                        else{
                            self.notMyFriendProfileLayoutSetup()
                        }
                        self.userLocationLbl.text = self.profileInfoDict.value(forKey: "userAddress") as? String

                        break
                    case 1:
                        self.myFriendProfileLayoutSetup()
                        break
                    default:
                        break
                    }

            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //AddPhotoToProfile Api call
    func addPhotoToProfileApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            var imgStr = ""
            if userPhotosToUpload != nil{
                let imageData:NSData = UIImagePNGRepresentation(userPhotosToUpload)! as NSData
                imgStr = "\(imageData.base64EncodedString(options: .lineLength64Characters))"
            }
            
            let paramertes = ["userId": UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                              "photo": imgStr]
                
            AlamofireIntegration.sharedInstance.addPhototoToProfileServiceDelegate = self
            AlamofireIntegration.sharedInstance.addPhotoToProfileApi(paramertes)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //AddPhotoToProfile Api result
    func addPhotoToProfileResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                CommonFxns.showAlert(self, message: "Image uploaded successfully!", title: messageText)
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
        switch indexPath.row {
        case 0:
            let myGroupVcObj = self.storyboard?.instantiateViewController(withIdentifier: "myGroupsVc") as! MyGroupsVC
            self.navigationController?.pushViewController(myGroupVcObj, animated: true)
        case 1:
            let myPlansVcObj = self.storyboard?.instantiateViewController(withIdentifier: "myPlansVc") as! MyPlansVC
            self.navigationController?.pushViewController(myPlansVcObj, animated: true)
        case 2:
            let addPeopleVcObj = self.storyboard?.instantiateViewController(withIdentifier: "addPeopleVc") as! AddPeopleVC
            addPeopleVcObj.isComingFromProfileScreen = true
            self.navigationController?.pushViewController(addPeopleVcObj, animated: true)
        default:
            break
        }
    }
    
    //MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfileVcImagesCollectionViewCell
       // let imageView = cell.viewWithTag(1) as! UIImageView
       // imageView.image = UIImage(named: imagesArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let cellWidth = (collectionView.frame.size.width-30)/4
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    //MARK:- Button Actions

    @IBAction func addPhotosBtnAction(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func seeAllPhotosBtnAction(_ sender: Any) {
    }
    
    //Back btn action
    @IBAction func backBtnAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingsBtnAction(_ sender: UIButton) {
        let settingsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "settingsVc") as! SettingsVC
        self.navigationController?.pushViewController(settingsVcObj, animated: true)
    }

    //Manage Connection with this user (Unfriend)
    @IBAction func manageConnectionBtnAction(_ sender: UIButton) {
        //Unfriend this user Api call
    }
    
    //Go to Edit MyProfile screen
    @IBAction func editBtnAction(_ sender: Any) {
        let editProfileVcObj = self.storyboard?.instantiateViewController(withIdentifier: "editProfileVc") as! EditProfileVC
        print("profileInfoDict :", profileInfoDict)
        editProfileVcObj.profileInfoDict = self.profileInfoDict
        self.navigationController?.pushViewController(editProfileVcObj, animated: true)
    }

    //Send request to this user
    @IBAction func addBtnAction(_ sender: UIButton) {
        //Send request APi call
    }
    
    //MARK:- Image Picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.userPhotosToUpload = pickedImage
            
            //show Alert
            
            self.addPhotoToProfileApi()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}
