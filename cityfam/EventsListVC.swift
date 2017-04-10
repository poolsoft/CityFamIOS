//
//  EventsListVC.swift
//  cityfam
//
//  Created by i mark on 10/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventsListVC: UIViewController {

    //MARK:- Outlets & Properties
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Methods
    
    
    
    
    //MARK: UITableView delgates & datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "eventDetailVc") as! EventDetailVC
        self.navigationController?.pushViewController(eventDetailVcObj, animated: true)
    }
    
    //MARK:- Button Actions
    
    


}
