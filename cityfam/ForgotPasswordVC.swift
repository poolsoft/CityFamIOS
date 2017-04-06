//
//  ForgotPasswordVC.swift
//  cityfam
//
//  Created by i mark on 06/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,ForgotPasswordServiceAlamofire {

    //MARK:- Outlets & Properties

    @IBOutlet var emailTxtField: UITextFieldCustomClass!
    
    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:- Methods
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Reset password Api Result
    func forgotPasswordResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.emailTxtField.text = ""
                CommonFxns.showAlert(self, message: passwordResetAlert, title: successAlertTitle)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //MARK:- Text Field delegates
    
    //Hide keyboard on return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Button Actions

    //Reset password button Action
    @IBAction func resetPasswordBtnAction(_ sender: UIButton) {
        if CommonFxns.trimString(string: self.emailTxtField.text!) != ""  {
            if CommonFxns.isValidEmail(testStr: CommonFxns.trimString(string: self.emailTxtField.text!)){
                if CommonFxns.isInternetAvailable(){
                    appDelegate.showProgressHUD(view: self.view)
                    let parameters = [
                        "emailId": CommonFxns.trimString(string: self.emailTxtField.text!)
                    ]
                    AlamofireIntegration.sharedInstance.forgotPasswordServiceDelegate = self
                    AlamofireIntegration.sharedInstance.forgotPasswordApi(parameters)
                }
                else{
                    CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
                }
            }
            else{
                CommonFxns.showAlert(self, message: enterValidEmailAlert, title: errorAlertTitle)
            }
        }
        else{
            CommonFxns.showAlert(self, message: enterEmailAlert, title: errorAlertTitle)
        }
    }
    
    //Back button action
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
