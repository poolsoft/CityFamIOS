//
//  ViewController.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/16/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

class LogInVC: UIViewController, loginServiceAlamofire,RegisterationServiceAlamofire, FacebookDelegate,UITextFieldDelegate,GoogleSignInService,GIDSignInDelegate, GIDSignInUIDelegate {
   
    //MARK:- Outlets & Properties
    
    @IBOutlet var googleView: GIDSignInButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var passwordTxtField: UITextFieldCustomClass!
    @IBOutlet var emailTxtField: UITextFieldCustomClass!
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    // dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
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
    
    //MARK:- Other Methods
    
    //Check validations to login into App
    func isValid()->Bool{
        if self.emailTxtField.text != "" && self.passwordTxtField.text != "" {
            if CommonFxns.isValidEmail(testStr: self.emailTxtField.text!){
                return true
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
    
    //Clear text of all textFields
    func resetData(){
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
    }
    
    //MARK:- Method to get Api's results
    
    //Server error alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //login Api Result
    func loginResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            
            if (result.value(forKey: "success")as! Int == 1){
                let resultDict = result.value(forKey: "result") as! NSDictionary
                
                //"result": { "userId": "8" , "eventsAddToCalendar": 0/1 },

                UserDefaults.standard.set(resultDict.value(forKey: "userId") as! String, forKey: USER_DEFAULT_userId_Key)
                UserDefaults.standard.set(resultDict.value(forKey: "userName") as! String, forKey: USER_DEFAULT_userName_Key)
                UserDefaults.standard.set(resultDict.value(forKey: "userImageUrl") as! String, forKey: USER_DEFAULT_userImage_Key)

                print(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)
                
                let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
                self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }

    //Registeration Api call
    
    func registerationResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            self.resetData()
            
            if (result.value(forKey: "success")as! Int == 1){
                let resultDict = result.value(forKey: "result") as! NSDictionary
                
                UserDefaults.standard.set(resultDict.value(forKey: "userId") as! String, forKey: USER_DEFAULT_userId_Key)
                UserDefaults.standard.set(resultDict.value(forKey: "userName") as! String, forKey: USER_DEFAULT_userName_Key)
                UserDefaults.standard.set(resultDict.value(forKey: "userImageUrl") as! String, forKey: USER_DEFAULT_userImage_Key)
                
                print(UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!)

                let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
                self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
     //MARK: UIButton actions
    
    //Login Api call button Action
    @IBAction func loginButtonAction(_ sender: Any) {
        if isValid() {
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                let parameters = [
                    "emailId": CommonFxns.trimString(string: self.emailTxtField.text!),
                    "password": CommonFxns.trimString(string: self.passwordTxtField.text!),
                    "deviceToken":"",
                    "deviceType":"iOS"
                ]
                AlamofireIntegration.sharedInstance.loginServiceDelegate = self
                AlamofireIntegration.sharedInstance.loginApi(parameters)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
    }

    @IBAction func googleBtnAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        //GoogleSignInIntegration.sharedInstance.delegate = self
        //GoogleSignInIntegration.sharedInstance.callGoogleSignIn()
    }
    
    @IBAction func googleViewAction(_ sender: Any) {
    }
    
    //login with facebook
    @IBAction func facebookBtnAction(_ sender: Any) {
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
        
        if CommonFxns.isInternetAvailable(){
            FacebookIntegration.sharedInstance.delegate = self
            FacebookIntegration.sharedInstance.fbLogin(reference: self)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }

    //Go to Sign Up screen
    @IBAction func createAccountButtonAction(_ sender: Any) {
        let signupVcObj = self.storyboard?.instantiateViewController(withIdentifier: "signupVc") as! SignupVC
        self.navigationController?.pushViewController(signupVcObj, animated: true)
    }
    
    //Forgot password Button Action
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "forgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    //MARK: Google sign in result
    
    func googleSignInData(_ result:NSDictionary){
        print(result,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    }
    
    func googleSignInError(_ result:String){
        print(result,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    }
    
    //MARK: Facebook api result

    func fbUserData(dict:NSDictionary){
        if let email = dict.value(forKey: "email"){
            let id = dict.value(forKey: "id")
            
            //print("facebook data", dict)
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                var name = ""
                
                if let firstName = dict.value(forKey: "first_name") as? String{
                    name = name + firstName
                }
                
                if let lastName = dict.value(forKey: "last_name")as? String{
                    name = name + lastName
                }
                var imgStr = ""
                
                if let picture = dict.value(forKey: "picture") as? NSDictionary{
                    if let data = picture.value(forKey: "data") as? NSDictionary{
                        if let urlStr = data.value(forKey: "url"){
                            do {
                                let url = NSURL(string: urlStr as! String)
                                let imageData:NSData = try NSData(contentsOf: url as! URL)
                                let image:UIImage = UIImage(data: imageData as Data)!
                                let imgData:NSData = UIImagePNGRepresentation(image)! as NSData
                                imgStr = "\(imgData.base64EncodedString(options: .lineLength64Characters))"
                            }
                            catch{
                            }
                        }
                    }
                }
                
                let parameters = [
                    "name": name,
                    "emailId": email,
                    "phone": "",
                    "password": "test",
                    "latitude": "",
                    "longitude": "",
                    "address": "",
                    "deviceToken":"",
                    "facebookId": id as! String,
                    "googleId": "",
                    "deviceType":"iOS",
                    "profilePicBase64":imgStr
                ]
                
                AlamofireIntegration.sharedInstance.registerationServiceDelegate = self
                AlamofireIntegration.sharedInstance.registerationApi(parameters as! [String : String])
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
        else{
            CommonFxns.showAlert(self, message: "Email not found", title: errorAlertTitle)
        }
    }
    
    
    //Google Login
    
    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID   // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                
                let userDataDict = [
                    "googleUserId" : userId,
                    "token" : idToken,
                    "fullName" : fullName,
                    "givenName" : givenName,
                    "familyName" : familyName,
                    "email" : email
                ]
                print(userDataDict)
                
                let imgStr = ""
                
                let parameters = [
                    "name": user.profile.name,
                    "emailId": user.profile.email,
                    "phone": "",
                    "password": "test",
                    "latitude": "",
                    "longitude": "",
                    "address": "",
                    "deviceToken":"",
                    "facebookId": "",
                    "googleId": "",
                    "deviceType":"iOS",
                    "profilePicBase64":imgStr
                ]
                
                AlamofireIntegration.sharedInstance.registerationServiceDelegate = self
                AlamofireIntegration.sharedInstance.registerationApi(parameters as! [String : String])
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
            

            //self.delegate?.googleSignInData(userDataDict as NSDictionary)
            GIDSignIn.sharedInstance().signOut()
            
        } else {
            let signInError = error.localizedDescription
            //self.delegate?.googleSignInError(signInError)
        }
    }
    private func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

}

