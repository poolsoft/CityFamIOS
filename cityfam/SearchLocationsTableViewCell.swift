//
//  SearchLocationsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 12/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class SearchLocationsTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var searchLocationNameLbl: UILabel!
    @IBOutlet var searchLocationAddressLbl: UILabel!
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
