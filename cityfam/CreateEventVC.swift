//
//  CreateEventVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class CreateEventVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var publicButton: UIButtonCustomClass!
    @IBOutlet var privateButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    @IBOutlet var labelUnderSegmentView: UILabelFontSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UIButton actions
    
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button == publicButton{
            publicButton.isSelected = true
            publicButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            privateButton.isSelected = false
            privateButton.backgroundColor = UIColor.clear
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = publicButtonDescription
        }
        else if button == privateButton{
            privateButton.isSelected = true
            privateButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            publicButton.isSelected = false
            publicButton.backgroundColor = UIColor.clear
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = privateButtonDescription
        }
        else{
            friendsButton.isSelected = true
            friendsButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            publicButton.isSelected = false
            publicButton.backgroundColor = UIColor.clear
            privateButton.isSelected = false
            privateButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = friendsButtonDescription
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteButtonAction(_ sender: Any) {
        let inviteFriendsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "inviteFriendsVc") as! InviteFriendsVC
        self.navigationController?.pushViewController(inviteFriendsVcObj, animated: true)
    }
}
