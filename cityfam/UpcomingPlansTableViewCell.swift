//
//  UpcomingPlansTableViewCell.swift
//  cityfam
//
//  Created by i mark on 09/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class UpcomingPlansTableViewCell: UITableViewCell {
    
    //MARK:- Outlets

    @IBOutlet var eventNameLbl: UILabel!
    @IBOutlet var eventLocationLbl: UILabel!
    @IBOutlet var hostImg: UIImageViewCustomClass!
    @IBOutlet var noOfPeopleAttendingEventLbl: UILabelFontSize!
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
