//
//  MyGroupsVcTableViewCell.swift
//  cityfam
//
//  Created by i mark on 09/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class MyGroupsVcTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var noOfMembersInGroupLbl: UILabelFontSize!
    @IBOutlet var groupNameLbl: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
