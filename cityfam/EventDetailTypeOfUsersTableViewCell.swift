//
//  EventDetailTypeOfUsersTableViewCell.swift
//  cityfam
//
//  Created by i mark on 11/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventDetailTypeOfUsersTableViewCell: UITableViewCell {
    
    //MARK:- Outlets & Properties

    @IBOutlet var typeOfPeopleLbl: UILabelFontSize!
    @IBOutlet var noOfPeopleCountLbl: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
