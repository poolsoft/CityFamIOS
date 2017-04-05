//
//  SignupVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SignupVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,RegisterationServiceAlamofire {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var phoneTxtField: UITextFieldCustomClass!
    @IBOutlet var emailTxtField: UITextFieldCustomClass!
    @IBOutlet var nameTxtField: UITextFieldCustomClass!
    @IBOutlet var passwordTxtField: UITextFieldCustomClass!
    @IBOutlet var locationTxtField: UITextFieldCustomClass!
    @IBOutlet var confirmPasswordTxtField: UITextFieldCustomClass!
    @IBOutlet var scrollView: UIScrollView!
    
    let imagePicker = UIImagePickerController()
    var profileImgToUpload:UIImage!
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(SignupVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(SignupVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    // dismissing keyboard on pressing return key
    
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

    //MARK:- Method to get Api's results

    func ServerError(){
       appDelegate.hideProgressHUD(view: self.view)
       CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Registeration Api call
    
    func registerationResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            self.resetData()
            
            if (result.value(forKey: "success")as! String == "1"){
                let resultDict = result.value(forKey: "result") as! NSDictionary//result.value("result") as! Array
                
                let userId:Int = resultDict.value(forKey: "userId") as! Int
                UserDefaults.standard.set(userId, forKey: USER_DEFAULT_userId_Key)
                
                let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
                self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }

    //MARK:- Other Methods
    
    //Method to clear all Textfields
    
    func resetData(){
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
        self.nameTxtField.text = ""
        self.confirmPasswordTxtField.text = ""
        self.locationTxtField.text = ""
        self.phoneTxtField.text = ""
    }
    
    //Method to check all validations of Input data

    func isValid()->Bool{
        if self.phoneTxtField.text != "" && self.emailTxtField.text != "" && self.nameTxtField.text != "" && self.passwordTxtField.text != "" && self.locationTxtField.text != "" && self.confirmPasswordTxtField.text != "" {
            
            if CommonFxns.isValidEmail(testStr: self.emailTxtField.text!){
                if self.passwordTxtField.text == self.confirmPasswordTxtField.text{
                    if (self.passwordTxtField.text?.characters.count)!>8{
                        return true
                    }
                    else{
                        CommonFxns.showAlert(self, message:incorrectPwdAlert, title: errorAlertTitle)
                        return false
                    }
                }
                else{
                    CommonFxns.showAlert(self, message:pwdMismatchAlert , title: errorAlertTitle)
                    return false
                }
            }
            else{
                CommonFxns.showAlert(self, message:enterValidEmailAlert , title: errorAlertTitle)
                return false
            }
        }
        else{
            CommonFxns.showAlert(self, message: allFieldRequiredAlert, title: errorAlertTitle)
            return false
        }
    }

    //MARK:- Image Picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            picker.allowsEditing = true
            picker.delegate = self
            self.profileImgView.contentMode = .scaleAspectFill
            self.profileImgView.image = pickedImage
            profileImgToUpload = self.profileImgView.image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Button Actions
    
    //SignUp Button Action
    @IBAction func signupButtonAction(_ sender: Any) {
        if isValid() {
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                var imgStr = ""
                if profileImgToUpload != nil{
                    let imageData:NSData = UIImagePNGRepresentation(profileImgToUpload)! as NSData
                    imgStr = "data:image/png;base64,\(imageData.base64EncodedString(options: .lineLength64Characters))"
                }
                
                let parameters = [
                    "name": CommonFxns.trimString(string: self.nameTxtField.text!),
                    "emailId": CommonFxns.trimString(string: self.emailTxtField.text!),
                    "phone": CommonFxns.trimString(string: self.phoneTxtField.text!),
                    "password": CommonFxns.trimString(string: self.passwordTxtField.text!),
                    "latitude": "1233.4545",
                    "longitude": "674623.567",
                    "address": CommonFxns.trimString(string: self.locationTxtField.text!),
                    "deviceToken":"",
                    "facebookId": "",
                    "googleId": "",
                    "deviceType":"iOS",
                    "profilePicBase64":imgStr
                ]

                AlamofireIntegration.sharedInstance.registerationServiceDelegate = self
                AlamofireIntegration.sharedInstance.registerationApi(parameters)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
    }

    //Login Button Action
    @IBAction func alreadyAccountButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //SignUp with Facebook button
    @IBAction func facebookBtnAction(_ sender: Any) {
    }
    
    //SignUp with google button
    @IBAction func googleBtnAction(_ sender: Any) {
    }
    
    //Profile image tap gesture
    @IBAction func profileImgSelectionAction(_ sender: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}
