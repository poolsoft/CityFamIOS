//
//  CommentsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CommentsVcServiceAlamofire,UITextFieldDelegate {

    //MARK:- Outlets & Properties
    
    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet var enterCommentTxtField: UITextFieldCustomClass!
    @IBOutlet weak var postCommentBgViewBottomConst: NSLayoutConstraint!

    var commentsListArr = [NSDictionary]()
    var eventId = String()
    
    var keyboardShow = false

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //commentsTableView.tableFooterView = UIView()
        self.getCommentsListApi()
        
        self.commentsTableView.estimatedRowHeight = 200
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        let commentsVC : CommentsVC = self.storyboard?.instantiateViewController(withIdentifier: "commentsVc") as! CommentsVC
        
        //Add Keyboard Notification observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(commentsVC.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(commentsVC.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if keyboardShow{
            let offset = CGPoint(x: 0, y: commentsTableView.contentSize.height - commentsTableView.frame.size.height)
            commentsTableView.contentOffset = offset
        }
    }

    //MARK:- Methods
    
    //MARk:- Keyboard delegates
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardShow = true
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.postCommentBgViewBottomConst.constant = keyboardSize.height-44
            }, completion: { (finished: Bool) in
            })
            
            viewDidLayoutSubviews()
            
            if self.commentsListArr.count != 0{
                let indexPath = IndexPath(row: self.commentsListArr.count-1, section: 0)
                self.commentsTableView.scrollToRow(at: indexPath,
                                           at: UITableViewScrollPosition.bottom, animated: false)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardShow = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.postCommentBgViewBottomConst.constant = CGFloat(zero)
        }, completion: { (finished: Bool) in
        })
    }
    
    //Api's results
    
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //Get Comments List Api Result
    func getCommentsApiResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.commentsListArr = result.value(forKey: "result") as! [NSDictionary]
                self.commentsTableView.reloadData()
                let indexPath = IndexPath(row: self.commentsListArr.count-1, section: 0)
                self.commentsTableView.scrollToRow(at: indexPath,
                                                   at: UITableViewScrollPosition.bottom, animated: false)
            }
            else{
                self.bgImg.isHidden = false
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Get Comments List Api call
    func getCommentsListApi() {
        self.bgImg.isHidden = true
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            
            EventsAlamofireIntegration.sharedInstance.commentsVcServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getCommentsListApi(eventId: eventId)
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //Add Comment Api Result
    func addCommentApiResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                //show posted comment locally
                self.bgImg.isHidden = true
                let dict = ["comment":CommonFxns.trimString(string: self.enterCommentTxtField.text!),
                            "timeElapsed":"",
                            "userId":UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                            "userImageUrl":"",
                            "userName":""] as [String : Any]
                self.commentsListArr.append(dict as NSDictionary)
                self.commentsTableView.reloadData()
                let indexPath = IndexPath(row: self.commentsListArr.count-1, section: 0)
                self.commentsTableView.scrollToRow(at: indexPath,
                                                   at: UITableViewScrollPosition.bottom, animated: false)
                
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Add Comment Api call
    func addCommentApi() {
        if CommonFxns.trimString(string: self.enterCommentTxtField.text!) != ""{
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                
                let parameters = ["userId": UserDefaults.standard.string(forKey: USER_DEFAULT_userId_Key)!,
                                  "eventId" : eventId,
                                  "comment" : self.enterCommentTxtField.text!] as [String : Any]
                EventsAlamofireIntegration.sharedInstance.commentsVcServiceDelegate = self
                EventsAlamofireIntegration.sharedInstance.addCommentApi(parameters: parameters)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
        else{
            CommonFxns.showAlert(self, message: postCommentValidation, title: errorAlertTitle)
        }
    }

    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.commentsListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:CommentsVcTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentsVcTableViewCell

        let dict = self.commentsListArr[indexPath.row]
        
        cell.userName.text = dict.value(forKey: "userName") as? String
        cell.commentLbl.text = dict.value(forKey: "comment") as? String
        cell.commentTimeLbl.text = dict.value(forKey: "timeElapsed") as? String

        if (dict.value(forKey: "userImageUrl") as? String) != nil{
            cell.userImg.sd_setImage(with: URL(string: (dict.value(forKey: "userImageUrl") as? String)!), placeholderImage: UIImage(named: "user.png"))
            cell.userImg.setShowActivityIndicator(true)
            cell.userImg.setIndicatorStyle(.gray)
        }
        else{
            cell.userImg.image = UIImage(named: "user.png")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //MARK:- Button Action
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postBtnAction(_ sender: Any) {
        self.addCommentApi()
    }
    
    //MARK:- TextField delegates
    
    func doneButtonTapped(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(CommentsVC.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString:NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLengthOfCommentTextField
    }

    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
