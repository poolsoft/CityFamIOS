//
//  HomePageTableViewCell.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet var eventCoverImg: UIImageView!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var userImg: UIImageViewCustomClass!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet var eventTimingDetail: UILabelFontSize!
}
