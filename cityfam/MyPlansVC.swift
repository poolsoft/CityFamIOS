//
//  MyPlansVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyPlansVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}