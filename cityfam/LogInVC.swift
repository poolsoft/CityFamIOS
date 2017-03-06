//
//  ViewController.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/16/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class LogInVC: UIViewController, loginServiceAlamofire, GoogleSignInService, FacebookDelegate,UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LogInVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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

    
     //MARK: UIButton actions
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
        self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
    }

    @IBAction func googleButtonAction(_ sender: Any) {
        GoogleSignInIntegration.sharedInstance.delegate = self
        GoogleSignInIntegration.sharedInstance.callGoogleSignIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        FacebookIntegration.sharedInstance.delegate = self
        FacebookIntegration.sharedInstance.fbLogin(self)
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
        let signupVcObj = self.storyboard?.instantiateViewController(withIdentifier: "signupVc") as! SignupVC
        self.navigationController?.pushViewController(signupVcObj, animated: true)

    }
    
    //MARK: Google sign in result
    
    func googleSignInData(_ result:NSDictionary){
        print(result)
    }
    
    func googleSignInError(_ result:String){
        print(result)
    }
    
    //MARK: Facebook api result
    
    func fbGraphApiData(_ dict:NSDictionary){
        print(dict)
    }
    
    //MARK: login api result
    
    func loginResult(_ result:AnyObject){
        
    }
    
    func loginError(){
        
    }



}

