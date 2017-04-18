//
//  EditProfileVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController,UITextFieldDelegate,EditUserProfileServiceAlamofire,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- Outlets & Propeties
    
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var emailTxtField: UITextFieldCustomClass!
    @IBOutlet var userNameTxtField: UITextFieldCustomClass!
    @IBOutlet var profileImg: UIImageViewCustomClass!
    @IBOutlet var locationTxtField: UITextFieldCustomClass!
    
    let imagePicker = UIImagePickerController()
    var profileImgToUpload:UIImage!
    var profileInfoDict = NSDictionary()
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        print("profileInfoDict  :", profileInfoDict)
        self.showSavedData()
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    //MARK:- Methods
    
    func showSavedData(){
        self.userNameTxtField.text = self.profileInfoDict.value(forKey: "userName") as? String
        self.locationTxtField.text = self.profileInfoDict.value(forKey: "userAddress") as? String
        if (profileInfoDict.value(forKey: "userImageUrl") as? String) != nil{
            self.profileImg.sd_setImage(with: URL(string: (profileInfoDict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
            self.profileImg.setShowActivityIndicator(true)
            self.profileImg.setIndicatorStyle(.gray)
        }
        else{
            self.profileImg.image = UIImage(named: "user.png")
        }
        self.emailTxtField.text = self.profileInfoDict.value(forKey: "userEmailAddress") as? String
    }
    
    
    func isValid()-> Bool{
        if (self.userNameTxtField.text != "") && (self.locationTxtField.text != ""){
            return true
        }
        else{
            CommonFxns.showAlert(self, message: allFieldsRequiredAlert, title: alertText)
            return false
        }
    }
    
    //MARK:- Image Picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.profileImg.contentMode = .scaleAspectFill
            self.profileImg.image = pickedImage
            profileImgToUpload = self.profileImg.image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // dismissing keyboard on pressing return key
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get CityFam user list Api call
    func editProfileApi() {
        if isValid(){
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                
                var base64ImgStr = ""
                if profileImgToUpload != nil{
                    let imageData:NSData = UIImagePNGRepresentation(profileImgToUpload)! as NSData
                    base64ImgStr = "\(imageData.base64EncodedString(options: .lineLength64Characters))"
                }
                
                let parameters = ["userId": UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                                  "name": CommonFxns.trimString(string: self.userNameTxtField.text!),
                                  "latitude": "1233.4545",
                                  "longitude": "674623.567",
                                  "address": CommonFxns.trimString(string: self.locationTxtField.text!),
                                  "userImageString": base64ImgStr]
                
                AlamofireIntegration.sharedInstance.editUserProfileServiceDelegate = self

                AlamofireIntegration.sharedInstance.editProfileApi(parameters)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
    }
    
//    {
//    "userId": "5",
//    "name": "kashish verma",
//    "latitude": "1233.4545",
//    "longitude": "674623.567",
//    "address": "123,avenue street, newyork",
//    "userImageString": base64
//    }
    //Get CityFam user list Api result
    func editUserProfileResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                _ = self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfileInfoNotification"), object: nil)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard notifications methods
    
    func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyBoardHeight
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ sender: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    //MARK:- Button Actions
    
    //updateLocation button
    @IBAction func chooselocationBtn(_ sender: UIButton) {
    }
    
    //UpdateProfile button
    @IBAction func doneBtnAction(_ sender: UIButton) {
        self.editProfileApi()
    }
    
    //Change profile image
    @IBAction func changeProfileImgBtnACtion(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Back btn action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
