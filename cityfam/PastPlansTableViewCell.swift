//
//  PastPlansTableViewCell.swift
//  cityfam
//
//  Created by i mark on 09/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class PastPlansTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet var eventLocationLbl: UILabel!
    @IBOutlet var eventNameLbl: UILabel!
    @IBOutlet var noOfPeopleAttendingEventLbl: UILabelFontSize!
    @IBOutlet var hostImg: UIImageViewCustomClass!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
