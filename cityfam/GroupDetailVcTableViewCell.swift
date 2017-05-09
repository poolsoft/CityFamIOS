//
//  GroupDetailVcTableViewCell.swift
//  cityfam
//
//  Created by i mark on 09/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class GroupDetailVcTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet var groupMemberProfileImg: UIImageViewCustomClass!
    @IBOutlet var groupMemberNameLbl: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
