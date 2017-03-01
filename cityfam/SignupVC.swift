//
//  SignupVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: UIButton actions
    
    @IBAction func signupButtonAction(_ sender: Any) {
        let tabBarControllerVcObj = self.storyboard?.instantiateViewController(withIdentifier: "tabBarControllerVc") as! TabBarControllerVC
        self.navigationController?.pushViewController(tabBarControllerVcObj, animated: true)
    }

    @IBAction func alreadyAccountButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
