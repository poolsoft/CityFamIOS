//
//  EventsListTableViewCell.swift
//  cityfam
//
//  Created by i mark on 10/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class EventsListTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var eventCoverImg: UIImageView!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var eventTimingDetail: UILabelFontSize!

    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
