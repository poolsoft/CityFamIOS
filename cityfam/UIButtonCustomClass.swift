//
//  UIButtonCustomClass.swift
//  SureshotGPS
//
//  Created by Piyush Gupta on 8/25/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

@IBDesignable class UIButtonCustomClass: UIButtonFontSize{
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    fileprivate var _round = false
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }
    
    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeRound()
        }
        get {
            return super.frame
        }
    }
    
    fileprivate func makeRound() {
        if self.round == true {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.width*0.5
        }
        else {
            self.layer.cornerRadius = 0
        }
    }

    
}
