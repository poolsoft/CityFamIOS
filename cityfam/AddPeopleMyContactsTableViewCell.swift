//
//  AddPeopleMyContactsTableViewCell.swift
//  cityfam
//
//  Created by i mark on 17/04/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

protocol MyContactsCellProtocol{
    func chooseMyContactsToAddInGroup(cell:AddPeopleMyContactsTableViewCell,sender:UIButton)
}

class AddPeopleMyContactsTableViewCell: UITableViewCell {

    //MARK:- Outlets & Properties

    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var chooseContactBtn: UIButton!
    
    var delegate:MyContactsCellProtocol?
    
    //MARK:- Methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Button Action
    
    @IBAction func chooseMyContactBtnAction(_ sender: UIButton) {
        self.delegate?.chooseMyContactsToAddInGroup(cell: self, sender: sender)
    }

}
