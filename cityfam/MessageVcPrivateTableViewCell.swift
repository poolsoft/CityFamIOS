//
//  MessageVcPrivateTableViewCell.swift
//  cityfam
//
//  Created by i mark on 12/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MessageVcPrivateTableViewCell: UITableViewCell {

    //MARK:- Outlets & properties
    
    @IBOutlet var msgTimeLbl: UILabelFontSize!
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var userNameLbl: UILabelFontSize!
    @IBOutlet var unreadMsgCountLbl: UILabelCustomClass!
    @IBOutlet var msgLbl: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
