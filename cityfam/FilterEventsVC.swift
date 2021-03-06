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
    
    @IBOutlet var distanceValueLbl: UILabelFontSize!
    @IBOutlet var nightBtn: UIButtonCustomClass!
    @IBOutlet var dayBtn: UIButtonCustomClass!
    @IBOutlet var anyTimeBtn: UIButtonCustomClass!
    @IBOutlet var allDaysBtn: UIButtonCustomClass!
    @IBOutlet var weekendsBtn: UIButtonCustomClass!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var distanceSwitchBtn: UISwitch!
    @IBOutlet var weekDaysBtn: UIButtonCustomClass!
    @IBOutlet var categoriesCollectionView: UICollectionView!
    @IBOutlet var categoriesCollectionViewHeightConst: NSLayoutConstraint!
    
    var categoriesListArr = [NSDictionary]()
    var listOfSelectedCategroies = [String]()

    var selectedCategoryId = ""
    var selectedTimeOfDay = ""
    var selectedWeekOfDay = ""
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allDaysBtnSelectedAction()
        self.anyTimeBtnSelectedAction()
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
                let resultArr = result.value(forKey: "result") as! [NSDictionary]
                let allInterestsDict = ["categoryId":"",
                            "categoryName":"All interests",
                            "state":1] as [String : Any]
                self.categoriesListArr.insert(allInterestsDict as NSDictionary, at: 0)

                var dict = NSMutableDictionary()
                for i in 0..<resultArr.count{
                    dict = resultArr[i].mutableCopy() as! NSMutableDictionary
                    dict.setObject(0, forKey: "state" as NSCopying)
                    self.categoriesListArr.append(dict)
                }
                
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
        
        let dict = self.categoriesListArr[indexPath.row]
        
        cell.categoryBtn.setTitle(dict.value(forKey: "categoryName") as? String, for: UIControlState.normal)
        
        if dict.value(forKey: "state") as! Int == 1{
            cell.categoryBtn.isSelected = true
            cell.categoryBtn.backgroundColor = appNavColor
        }
        else{
            cell.categoryBtn.isSelected = false
            cell.categoryBtn.backgroundColor = UIColor.clear
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = ((self.categoriesCollectionView.frame.size.width)*0.29)
            let size = CGSize(width: cellWidth, height: 32)
            return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell:FilterEventCategoriesCollectionViewCell = self.categoriesCollectionView.cellForItem(at: indexPath) as! FilterEventCategoriesCollectionViewCell

        print("categoriesListArr",categoriesListArr)
        if self.categoriesListArr[indexPath.row].value(forKey: "state") as! Int == 1{
            cell.categoryBtn.isSelected = false
            cell.categoryBtn.backgroundColor = UIColor.clear
            self.listOfSelectedCategroies = self.listOfSelectedCategroies.filter{$0 != self.categoriesListArr[indexPath.row].value(forKey: "categoryId") as! String}
            self.categoriesListArr[indexPath.row].setValue(0, forKey: "state")
            print("removed",listOfSelectedCategroies)
        }
        else{
            cell.categoryBtn.isSelected = true
            cell.categoryBtn.backgroundColor = appNavColor
            self.listOfSelectedCategroies.append(self.categoriesListArr[indexPath.row].value(forKey: "categoryId") as! String)
            self.categoriesListArr[indexPath.row].setValue(1, forKey: "state")
            print("inserted",listOfSelectedCategroies)
        }
    }
    
    //MARK: Button Actions

    //Distance lider value change handling
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
