//
//  InvitationsScreenTableViewCell.swift
//  cityfam
//
//  Created by i mark on 06/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InvitationsScreenTableViewCell: UITableViewCell {
    
    //MARK:- Outlets & Properties
    
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var eventTimingDetail: UILabelFontSize!
    @IBOutlet var noOfPeopleAttendingEventCountLbl: UILabelFontSize!
    @IBOutlet var interestedBtn: UIButtonCustomClass!
    @IBOutlet var acceptBtn: UIButtonCustomClass!
    @IBOutlet var declineBtn: UIButtonCustomClass!
    
    //MARK:- View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
