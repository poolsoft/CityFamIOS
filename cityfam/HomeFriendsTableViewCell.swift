//
//  HomeFriendsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 18/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class HomeFriendsTableViewCell: UITableViewCell {

    @IBOutlet var userImg: UIImageViewCustomClass!
    
    @IBOutlet var eventCoverImg: UIImageView!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var eventTimingDetail: UILabelFontSize!
    @IBOutlet var noOfPeopleAttendingEventCountLbl: UILabelFontSize!
    @IBOutlet var interestedBtn: UIButtonCustomClass!
    @IBOutlet var acceptBtn: UIButtonCustomClass!
    @IBOutlet var declineBtn: UIButtonCustomClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
