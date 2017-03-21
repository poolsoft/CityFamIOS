//
//  MyGroupsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/2/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyGroupsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet var addNewGroupView: UIView!
    @IBOutlet var myGroupsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myGroupsTableView.tableFooterView = UIView()
    }
    
    // dismissing keyboard on pressing return key
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        addNewGroupView.isHidden = true
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
       addNewGroupView.isHidden = true
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        addNewGroupView.isHidden = false
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
        let groupDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "groupDetailVc") as! GroupDetailVC
        self.navigationController?.pushViewController(groupDetailVcObj, animated: true)
    }


}
