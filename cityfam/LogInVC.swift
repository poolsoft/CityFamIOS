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

    @IBAction func googleButtonAction(_ sender: Any) {
        GoogleSignInIntegration.sharedInstance.delegate = self
        GoogleSignInIntegration.sharedInstance.callGoogleSignIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        FacebookIntegration.sharedInstance.delegate = self
        FacebookIntegration.sharedInstance.fbLogin(self)
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
