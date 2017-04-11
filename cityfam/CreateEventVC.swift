//
//  CreateEventVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class CreateEventVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CreateEventServiceAlamofire,UIPickerViewDelegate {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var eventImgView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var publicButton: UIButtonCustomClass!
    @IBOutlet var privateButton: UIButtonCustomClass!
    @IBOutlet var friendsButton: UIButtonCustomClass!
    @IBOutlet var inviteFriendsBtn: UIButtonFontSize!
    @IBOutlet var addTicketsLinkTxtField: UITextFieldCustomClass!
    @IBOutlet var eventTitleTxtField: UITextFieldFontSize!
    @IBOutlet var eventDetailTxtFields: UITextFieldFontSize!
    @IBOutlet var addCategoriesTxtFields: UITextFieldCustomClass!
    @IBOutlet var endTimeTxtField: UITextFieldCustomClass!
    @IBOutlet var startTimeTxtField: UITextFieldCustomClass!
    @IBOutlet var labelUnderSegmentView: UILabelFontSize!
    @IBOutlet var allowGuestToInviteSwitch: UISwitch!
    @IBOutlet var eventLocationLbl: UILabel!

    var eventImgToUpload:UIImage!
    let imagePicker = UIImagePickerController()
    let startDatePickerView:UIDatePicker = UIDatePicker()
    let endDatePickerView:UIDatePicker = UIDatePicker()

    var categoryPicker:UIPickerView = UIPickerView()
    var categoriesListArr = [NSDictionary]()
    var categoryId = String()
    var whoCanSeeValueLbl = ""
    var privateUserListArr = [NSDictionary]()
    var allowGuestSwitchSelectedState = "1"
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.whoCanSeeValueLbl = "private"
        imagePicker.delegate = self
        endDatePickerView.minimumDate = Date()
        startDatePickerView.minimumDate = Date()

        // AllowGuestToInvite Switch Control
        self.allowGuestToInviteSwitch.addTarget(self, action: #selector(CreateEventVC.allowGuestToInviteSwitchValueChanged(sender:)), for: .valueChanged)
    }
    
    //MARK:- Methods
    
    //Api's results
    //Server error Alert
    func ServerError(){
        appDelegate.hideProgressHUD(view: self.view)
        CommonFxns.showAlert(self, message: networkOperationErrorAlert, title: errorAlertTitle)
    }
    
    //get categoories Api call
    func getEventCategoryApi() {
        if CommonFxns.isInternetAvailable(){
            appDelegate.showProgressHUD(view: self.view)
            EventsAlamofireIntegration.sharedInstance.createEventServiceDelegate = self
            EventsAlamofireIntegration.sharedInstance.getEventCategoryApi()
        }
        else{
            CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
        }
    }
    
    //get categoories Api result
    func getEventCategoryResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            if (result.value(forKey: "success")as! Int == 1){
                self.categoriesListArr = result.value(forKey: "result") as! [NSDictionary]
                
                //show categoryPicker
                self.addCategoriesTxtFields.isUserInteractionEnabled = true
                self.categoryPicker.delegate = self
                self.categoryPicker.reloadAllComponents()
                self.addCategoriesTxtFields.inputView = self.categoryPicker
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Create event Api call
    
    func createEventApi(){
        if isValid() {
            if CommonFxns.isInternetAvailable(){
                appDelegate.showProgressHUD(view: self.view)
                var imgStr = ""
                if eventImgToUpload != nil{
                    let imageData:NSData = UIImagePNGRepresentation(eventImgToUpload)! as NSData
                    imgStr = "\(imageData.base64EncodedString(options: .lineLength64Characters))"
                }
                
                for i in 0..<2{
                    self.privateUserListArr.append(["emailID":"abc@gmail.com","userID":"","name":"Ankita"])
                }
                
                let parameters = [
                    "userId":"23",
                    "eventImage":imgStr,
                    "eventName":CommonFxns.trimString(string: self.eventTitleTxtField.text!),
                    "eventStartTime": self.startTimeTxtField.text!,//"17/3/2017-12:36"
                    "eventEndTime":self.endTimeTxtField.text!,//"18/3/2017-12:36",//
                    "whoCanSee":self.whoCanSeeValueLbl,
                    "privateUserList":privateUserListArr,
                    "allowGuestsToInviteOthers":allowGuestSwitchSelectedState,
                    "latitude": "1233.4545",
                    "longitude": "674623.567",
                    "placeName": "rock garden, chandigarh",
                    "categories": self.categoryId,
                    "eventDescription":CommonFxns.trimString(string: self.eventDetailTxtFields.text!),
                    "ticketLink":"https://www.ticket.com"
                    ] as [String : Any]
                
                print(parameters)
                
                EventsAlamofireIntegration.sharedInstance.createEventServiceDelegate = self
                EventsAlamofireIntegration.sharedInstance.createEventApi(parameters)
            }
            else{
                CommonFxns.showAlert(self, message: internetConnectionError, title: oopsText)
            }
        }
    }
    
    //Create event Api result
    func createEventResult(_ result:AnyObject){
        DispatchQueue.main.async( execute: {
            appDelegate.hideProgressHUD(view: self.view)
            
            if (result.value(forKey: "success")as! Int == 1){
                self.resetData()
                CommonFxns.showAlert(self, message: "Event Created successfully!", title: successAlertTitle)
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //Other methods
    
    //Method to check validations to create an event
    func isValid()->Bool{
        
        if self.eventTitleTxtField.text != "" && self.startTimeTxtField.text != "" && self.eventDetailTxtFields.text != "" {
            return true
        }
        else{
            CommonFxns.showAlert(self, message: "Enter required fields.", title: errorAlertTitle)
        }
        return true
    }
    
    func resetData(){
        self.eventImgToUpload = nil
        self.eventImgView.image = UIImage(named: "eventCreateAddImage.png")
        self.eventTitleTxtField.text = ""
        self.startTimeTxtField.text = ""
        self.endTimeTxtField.text = ""
        //eventloaction
        self.eventDetailTxtFields.text = ""
        self.addCategoriesTxtFields.text = ""
        self.categoryId = ""
        self.addTicketsLinkTxtField.text = ""
    }
    
    // MARK: TextField delegates
    
    // dismissing keyboard on pressing return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(CreateEventVC.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        
        switch textField.tag {
        case 112:
            //add done button
            textField.inputAccessoryView = toolbar
            //Show date picker
            startDatePickerView.datePickerMode = UIDatePickerMode.date
            textField.inputView = startDatePickerView
            startDatePickerView.addTarget(self, action: #selector(CreateEventVC.startTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            break
        case 113:
            //add done button
            textField.inputAccessoryView = toolbar
            //Show date picker
            endDatePickerView.datePickerMode = UIDatePickerMode.date
            textField.inputView = endDatePickerView
            endDatePickerView.addTarget(self, action: #selector(CreateEventVC.endTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            break
        case 115:
            //add done button
            textField.inputAccessoryView = toolbar
            
            if self.categoriesListArr.count == 0{
                textField.isUserInteractionEnabled = false
                //Get categories list
                self.getEventCategoryApi()
            }
            break
        default:
            break
        }
        return true
    }
    
    //keyboard Done button
    func doneButtonTapped(){
        self.view.endEditing(true)
    }
    
    func startTimePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy-hh:mm"
        
        let date = sender.date
        self.startTimeTxtField.text = dateFormatter.string(from: date)
    }
    
    func endTimePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yyyy-hh:mm"
        
        let date = sender.date
        self.endTimeTxtField.text = dateFormatter.string(from: date)
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
    
    //MARK:- Picker view delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.categoriesListArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return categoriesListArr[row].value(forKey: "categoryName") as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.addCategoriesTxtFields.text = categoriesListArr[row].value(forKey: "categoryName") as? String
        categoryId = (categoriesListArr[row].value(forKey: "categoryId") as? String)!
    }
    
    //MARK:- Methods to upload image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.allowsEditing = true
            picker.delegate = self
            self.eventImgView.image = pickedImage
            eventImgToUpload = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePicker(imagePicker: UIPickerView!, pickedImage image: UIImage!) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIButton actions
    
    //Segment Control button
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button == publicButton{
            publicButton.isSelected = true
            publicButton.backgroundColor = appNavColor
            privateButton.isSelected = false
            privateButton.backgroundColor = UIColor.clear
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = publicButtonDescription
            self.whoCanSeeValueLbl = "public"
        }
        else if button == privateButton{
            privateButton.isSelected = true
            privateButton.backgroundColor = appNavColor
            publicButton.isSelected = false
            publicButton.backgroundColor = UIColor.clear
            friendsButton.isSelected = false
            friendsButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = privateButtonDescription
            self.whoCanSeeValueLbl = "private"
            
        }
        else{
            friendsButton.isSelected = true
            friendsButton.backgroundColor = appNavColor
            publicButton.isSelected = false
            publicButton.backgroundColor = UIColor.clear
            privateButton.isSelected = false
            privateButton.backgroundColor = UIColor.clear
            labelUnderSegmentView.text = friendsButtonDescription
            self.whoCanSeeValueLbl = "friends"
        }
    }
    
    //Handle allowGuestToInvite Switch control
    func allowGuestToInviteSwitchValueChanged(sender: UISwitch){
        if self.allowGuestToInviteSwitch.isOn{
            self.allowGuestSwitchSelectedState = "1"
        }
        else{
            self.allowGuestSwitchSelectedState = "0"
        }
    }
    
    //Create Event button Action
    @IBAction func tickBtnAction(_ sender: UIButton) {
        createEventApi()
    }
    
    //invite button Action
    @IBAction func inviteButtonAction(_ sender: Any) {
        let inviteFriendsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "inviteFriendsVc") as! InviteFriendsVC
        self.navigationController?.pushViewController(inviteFriendsVcObj, animated: true)
    }
    
    //Enter event location button action
    @IBAction func eventLocationBtnAction(_ sender: Any) {
        let inviteFriendsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "searchLocationVc") as! SearchLocationVC
        self.navigationController?.pushViewController(inviteFriendsVcObj, animated: true)
    }
    
    //Upload Image
    @IBAction func uploadImgTapGestureAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Back button action
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
