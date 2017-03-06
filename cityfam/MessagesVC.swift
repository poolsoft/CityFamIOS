//
//  MessagesVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/6/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
