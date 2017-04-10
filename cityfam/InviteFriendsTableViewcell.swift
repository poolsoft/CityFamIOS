//
//  InviteFriendsTableViewcell.swift
//  cityfam
//
//  Created by i mark on 08/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class InviteFriendsTableViewcell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var userEmailLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userImgView: UIImageView!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
