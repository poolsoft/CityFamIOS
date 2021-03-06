//
//  HomePageTableViewCell.swift
//  cityfam
//
//  Created by Piyush Gupta on 3/1/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

protocol HomePageTableViewCellProtocol {
    func exploreTabChangeStatusOfEventSegmentControl(cell: HomePageTableViewCell,sender:UIButton)
}

class HomePageTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var eventCoverImg: UIImageView!
    @IBOutlet var eventName: UILabelFontSize!
    @IBOutlet var userImg: UIImageViewCustomClass!
    @IBOutlet var eventTimingDetail: UILabelFontSize!
    @IBOutlet var noOfPeopleAttendingEventCountLbl: UILabelFontSize!
    @IBOutlet var interestedBtn: UIButtonCustomClass!
    @IBOutlet var acceptBtn: UIButtonCustomClass!
    @IBOutlet var declineBtn: UIButtonCustomClass!
    
    var delegate: HomePageTableViewCellProtocol?
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Button IBAction
    
    @IBAction func changeStatusOfEventSegmentControlAction(_ sender: UIButtonCustomClass) {
        self.delegate?.exploreTabChangeStatusOfEventSegmentControl(cell: self, sender: sender)
    }
    
}
