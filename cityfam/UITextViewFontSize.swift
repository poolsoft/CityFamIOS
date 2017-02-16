//
//  UITextFontSize.swift
//  Myc1rcle
//
//  Created by Piyush Gupta on 2/11/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class UITextViewFontSize: UITextView {

    override func awakeFromNib() {
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font!.pointSize
        if (UIScreen.main.bounds.height != 736){
            self.font = self.font!.withSize(currentSize-3)
        }
    }

}
