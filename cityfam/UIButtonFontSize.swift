//
//  UIButtonFontSize.swift
//  SureshotGPS
//
//  Created by Piyush Gupta on 9/12/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

class UIButtonFontSize: UIButton {

    override func awakeFromNib() {
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.titleLabel?.font.pointSize
        let fontDescriptor = self.titleLabel?.font.fontDescriptor
        if (UIScreen.main.bounds.height != 736){
            self.titleLabel?.font = UIFont(descriptor: fontDescriptor!, size: currentSize!-3)
        }
    }


}
