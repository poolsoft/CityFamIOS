//
//  SearchFriendsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 13/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SearchFriendsTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var userNameLbl: UILabelFontSize!
    @IBOutlet var userStatusLbl: UILabelCustomClass!
    @IBOutlet var userStatusBtn: UIButton!
    @IBOutlet var userPendingStatusLbl: UILabelCustomClass!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    

}
