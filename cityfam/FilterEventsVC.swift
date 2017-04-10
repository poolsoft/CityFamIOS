//
//  FilterEventsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class FilterEventsVC: UIViewController {

    //MARK:- Outlets & Properties
    
    @IBOutlet var nightBtn: UIButtonCustomClass!
    @IBOutlet var dayBtn: UIButtonCustomClass!
    @IBOutlet var anyTimeBtn: UIButtonCustomClass!
    @IBOutlet var distanceSwitchBtn: UISwitch!
    @IBOutlet var allDaysBtn: UIButtonCustomClass!
    @IBOutlet var weekendsBtn: UIButtonCustomClass!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var weekDaysBtn: UIButtonCustomClass!
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK:- Methods
    
    
    //MARK:- Button Actions

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
        
    }
    
    @IBAction func daysSegmentControlBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func timeSegmentControlBtnAction(_ sender: UIButton) {
    }

    //Back button Action
    @IBAction func backButtonAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
    }
}
