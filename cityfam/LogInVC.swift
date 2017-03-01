//
//  ViewController.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/16/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class LogInVC: UIViewController, loginServiceAlamofire, GoogleSignInService, FacebookDelegate {
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

