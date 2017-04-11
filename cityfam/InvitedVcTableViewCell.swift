//
//  InvitedVcTableViewCell.swift
//  cityfam
//
//  Created by i mark on 11/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InvitedVcTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties

    @IBOutlet var userNameLbl: UILabelFontSize!
    @IBOutlet var userStatusLbl: UILabelCustomClass!
    @IBOutlet var userImg: UIImageViewCustomClass!
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
