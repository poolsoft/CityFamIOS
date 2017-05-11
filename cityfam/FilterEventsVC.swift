//
//  FilterEventsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class FilterEventsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GetEventCategoryServiceAlamofire {

    //MARK:- Outlets & Properties
    
    @IBOutlet var nightBtn: UIButtonCustomClass!
    @IBOutlet var dayBtn: UIButtonCustomClass!
    @IBOutlet var anyTimeBtn: UIButtonCustomClass!
    @IBOutlet var distanceSwitchBtn: UISwitch!
    @IBOutlet var allDaysBtn: UIButtonCustomClass!
    @IBOutlet var weekendsBtn: UIButtonCustomClass!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var weekDaysBtn: UIButtonCustomClass!
    @IBOutlet var categoriesCollectionView: UICollectionView!
    @IBOutlet var categoriesCollectionViewHeightConst: NSLayoutConstraint!
    
    var categoriesListArr = [NSDictionary]()
    var selectedCategoryId = ""
    var selectedTimeOfDay = ""
    var selectedWeekOfDay = ""
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEventCategoryApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
            EventsAlamofireIntegration.sharedInstance.getEventCategoryServiceDelegate = self
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
                let dict = ["categoryId":"",
                            "categoryName":"All interests"]
                
                self.categoriesListArr.append(dict as NSDictionary)
                self.categoriesCollectionView.reloadData()
                let height = self.categoriesCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.categoriesCollectionViewHeightConst.constant = height
            }
            else{
                CommonFxns.showAlert(self, message: (result.value(forKey: "error") as? String)!, title: errorAlertTitle)
            }
        })
    }
    
    //MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoriesListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterEventCategoriesCollectionViewCell
        cell.categoryBtn.tag = indexPath.row
        cell.categoryBtn.addTarget(self, action: #selector(FilterEventsVC.categoriesBtnTappedAction(sender:cell:)), for: .touchUpInside)
        
        let dict = self.categoriesListArr[indexPath.row]
        
        cell.categoryBtn.setTitle(dict.value(forKey: "categoryName") as? String, for: UIControlState.normal)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = ((self.categoriesCollectionView.frame.size.width)*0.29)
            let size = CGSize(width: cellWidth, height: 32)
            return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    //MARK:- Button Actions
    
    func categoriesBtnTappedAction(sender:UIButton,cell:FilterEventCategoriesCollectionViewCell){
        for i in 0..<self.categoriesListArr.count{
            if i == sender.tag{
                self.selectedCategoryId = self.categoriesListArr[sender.tag].value(forKey: "categoryId") as! String
                
                let button = cell.categoryBtn.viewWithTag(i) as! UIButton
                button.isSelected = true
                button.backgroundColor = appNavColor
            }
            else{
                let button = cell.categoryBtn.viewWithTag(i) as! UIButton
                button.isSelected = false
                button.backgroundColor = UIColor.clear
            }
        }
    }
    
    @IBAction func distanceSwitchValueChanged(_ sender: UISwitch) {
    }

    //Fetch events according to filter input data
    @IBAction func tickBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "filterEventsNotification"),
             object: nil,
             userInfo:["distance": "51","categories": "222","daysOfWeek": "","timeOfDay": ""])
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func distanceSliderAction(_ sender: UISlider) {
        
    }

    @IBAction func resetAllFiltersBtnAction(_ sender: Any) {
        self.allDaysBtnSelectedAction()
        self.anyTimeBtnSelectedAction()
    }
    
    @IBAction func daysSegmentControlBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 111:
            self.allDaysBtnSelectedAction()
            break
        case 112:
            self.weekendsBtn.isSelected = true
            self.weekendsBtn.backgroundColor = appNavColor
            self.weekDaysBtn.isSelected = false
            self.weekDaysBtn.backgroundColor = UIColor.clear
            self.allDaysBtn.isSelected = false
            self.allDaysBtn.backgroundColor = UIColor.clear
            break
        case 113:
            self.weekDaysBtn.isSelected = true
            self.weekDaysBtn.backgroundColor = appNavColor
            self.weekendsBtn.isSelected = false
            self.weekendsBtn.backgroundColor = UIColor.clear
            self.allDaysBtn.isSelected = false
            self.allDaysBtn.backgroundColor = UIColor.clear
            break
        default:
            break
        }
    }
    
    @IBAction func timeSegmentControlBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 114:
            self.anyTimeBtnSelectedAction()
            break
        case 115:
            self.dayBtn.isSelected = true
            self.dayBtn.backgroundColor = appNavColor
            self.anyTimeBtn.isSelected = false
            self.anyTimeBtn.backgroundColor = UIColor.clear
            self.nightBtn.isSelected = false
            self.nightBtn.backgroundColor = UIColor.clear
            break
        case 116:
            self.nightBtn.isSelected = true
            self.nightBtn.backgroundColor = appNavColor
            self.dayBtn.isSelected = false
            self.dayBtn.backgroundColor = UIColor.clear
            self.anyTimeBtn.isSelected = false
            self.anyTimeBtn.backgroundColor = UIColor.clear
            break
        default:
            break
        }
    }

    //Back button Action
    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    func allDaysBtnSelectedAction(){
        self.allDaysBtn.isSelected = true
        self.allDaysBtn.backgroundColor = appNavColor
        self.weekendsBtn.isSelected = false
        self.weekendsBtn.backgroundColor = UIColor.clear
        self.weekDaysBtn.isSelected = false
        self.weekDaysBtn.backgroundColor = UIColor.clear
    }
    
    func anyTimeBtnSelectedAction(){
        self.anyTimeBtn.isSelected = true
        self.anyTimeBtn.backgroundColor = appNavColor
        self.dayBtn.isSelected = false
        self.dayBtn.backgroundColor = UIColor.clear
        self.nightBtn.isSelected = false
        self.nightBtn.backgroundColor = UIColor.clear
    }
    
    
    
}

//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
