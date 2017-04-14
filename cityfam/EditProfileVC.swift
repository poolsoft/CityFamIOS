//
//  EditProfileVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController,UITextFieldDelegate,EditUserProfileServiceAlamofire {
    
    //MARK:- Outlets & Propeties
    
    @IBOutlet var scrollView: UIScrollView!

    //MARK:- View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    //MARK:- Methods
    
    // dismissing keyboard on pressing return key
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get CityFam user list Api call
    func editProfileApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            AlamofireIntegration.sharedInstance.editUserProfileServiceDelegate = self
            
            let parameters = [String : String]()
            
            AlamofireIntegration.sharedInstance.editProfileApi(parameters)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Get CityFam user list Api result
    func editUserProfileResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                
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

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
