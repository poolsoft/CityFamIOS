//
//  MyFriendsOrContactsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 03/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyFriendsOrContactsTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userImg: UIImageViewCustomClass!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
