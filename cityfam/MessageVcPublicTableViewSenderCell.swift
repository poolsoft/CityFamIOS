//
//  MessageVcPublicTableViewSenderCell.swift
//  cityfam
//
//  Created by i mark on 12/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MessageVcPublicTableViewSenderCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var msgLbl: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
