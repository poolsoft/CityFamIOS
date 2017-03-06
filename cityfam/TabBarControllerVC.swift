//
//  TabBarControllerVC.swift
//  cityfam
//
//  Created by Piyush Gupta on 2/28/17.
//  Copyright © 2017 Piyush Gupta. All rights reserved.
//

import UIKit

class TabBarControllerVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.white
        }
        
        // set red as selected tab item background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        let selectedColor = UIColor(colorLiteralRed: 208/255, green: 74/255, blue: 88/255, alpha: 1)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: selectedColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border (in conjuction with above)
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
        // set badge
        setBadges(badgeValues: [0,0,0,0,5])
        
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UITabBarController {
    func setBadges(badgeValues:[Int]){
        
        var labelExistsForIndex = [Bool]()
        for _ in badgeValues {
            labelExistsForIndex.append(false)
        }
        
        for view in self.tabBar.subviews {
            if view.isKind(of: PGTabBadge.self) {
                let badgeView = view as! PGTabBadge
                let index = badgeView.tag
                if badgeValues[index]==0 {
                    badgeView.removeFromSuperview()
                }
                labelExistsForIndex[index]=true
                badgeView.text = String(badgeValues[index])
            }
        }
        
        for i in 0 ..< labelExistsForIndex.count {
            if labelExistsForIndex[i] == false {
                if badgeValues[i] > 0 {
                    addBadge(index: i, value: badgeValues[i], color:UIColor(red: 208/255, green: 74/255, blue: 88/255, alpha: 1), font: UIFont.systemFont(ofSize: 11))
                }
            }
        }
    }
    
    func addBadge(index:Int,value:Int, color:UIColor, font:UIFont){
        let itemPosition = CGFloat(index+1)
        let itemWidth:CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let xOffset:CGFloat = 12
        let yOffset:CGFloat = 0
        let badgeView = PGTabBadge()
        badgeView.frame.size=CGSize(width: 18, height: 18)
        badgeView.center=CGPoint(x: (itemWidth * itemPosition)-(itemWidth/2)+xOffset, y: yOffset)
        badgeView.layer.cornerRadius=badgeView.bounds.width/2
        badgeView.clipsToBounds=true
        badgeView.textColor=color
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = String(value)
        badgeView.backgroundColor = UIColor.white
        badgeView.layer.borderWidth = 2
        badgeView.layer.borderColor = color.cgColor
        badgeView.tag=index
        tabBar.addSubview(badgeView)
    }
}

class PGTabBadge: UILabel {
    
}
