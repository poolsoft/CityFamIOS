//
//  InterestedVcTableViewCell.swift
//  cityfam
//
//  Created by i mark on 11/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InterestedVcTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties

    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var userNamelbl: UILabelFontSize!
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
