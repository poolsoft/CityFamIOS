//
//  UITextViewCustomClass.swift
//  Myc1rcle
//
//  Created by Piyush Gupta on 2/11/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewCustomClass: UITextViewFontSize {
    
    
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
          self.contentInset.left = 20
     }
 
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }

}
