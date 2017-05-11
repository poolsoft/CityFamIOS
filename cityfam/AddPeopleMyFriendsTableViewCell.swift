//
//  AddPeopleMyFriendsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 17/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

protocol MyFriendCellProtocol{
    func chooseMyFriendsToAddInGroup(cell:AddPeopleMyFriendsTableViewCell,sender:UIButton)
}

class AddPeopleMyFriendsTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties
    
    @IBOutlet var chooseFriendBtn: UIButton!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    
    var delegate: MyFriendCellProtocol?
    
    //MARK:- Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Button Action

    @IBAction func chooseContactBtnAction(_ sender: UIButton) {
        self.delegate?.chooseMyFriendsToAddInGroup(cell: self,sender:sender)
    }
}
