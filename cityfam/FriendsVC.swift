//
//  FriendsVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var requestTableView: UITableView!
    @IBOutlet var searchButton: UIButtonCustomClass!
    @IBOutlet var requestsButton: UIButtonCustomClass!
    @IBOutlet var searchView: UIView!
    @IBOutlet var requestsView: UIView!
    @IBOutlet var searchBarViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.tableFooterView = UIView()
        requestTableView.tableFooterView = UIView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: UITableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 1 {
            return 5
        }
        else{
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: UIButton actions
    
    @IBAction func segmentButtonsAction(_ sender: Any) {
        let button = sender as! UIButtonCustomClass
        if button.tag == 1{
            searchButton.isSelected = true
            searchButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            requestsButton.isSelected = false
            requestsButton.backgroundColor = UIColor.clear
            searchView.isHidden = false
            requestsView.isHidden = true
            searchBarViewHeightConstraint.constant = 50
        }
        else{
            searchButton.isSelected = false
            searchButton.backgroundColor = UIColor.clear
            requestsButton.isSelected = true
            requestsButton.backgroundColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
            searchView.isHidden = true
            requestsView.isHidden = false
            searchBarViewHeightConstraint.constant = 0
        }
    }
    
    
}
