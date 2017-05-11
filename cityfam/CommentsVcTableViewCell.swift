//
//  CommentsVcTableViewCell.swift
//  cityfam
//
//  Created by i mark on 10/05/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class CommentsVcTableViewCell: UITableViewCell {
    
    //MARK:- Outlets & Proprties
    
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var commentTimeLbl: UILabelFontSize!
    @IBOutlet var commentLbl: UILabelFontSize!
    @IBOutlet var userName: UILabelFontSize!
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
