//
//  UIColor+Wolox.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func woloxBackgroundColor() -> UIColor {
        if #available(iOS 11.0, *) {
            return UIColor.init(named: "woloxBackgroundColor") ?? UIColor(red: 0.0, green: 0.68, blue: 0.93, alpha: 1.0)
        } else {
            return UIColor(red: 0.0, green: 0.68, blue: 0.93, alpha: 1.0)
        }
    }
    
    class func woloxBackgroundLightColor() -> UIColor {
        if #available(iOS 11.0, *) {
            return UIColor.init(named: "woloxBackgroundLightColor") ?? UIColor(red: 231, green: 245, blue: 249, alpha: 1.0)
        } else {
            return UIColor(red: 231, green: 245, blue: 249, alpha: 1.0)
        }
    }
    
    class func woloxTabBarBackgroundColor() -> UIColor {
        if #available(iOS 11.0, *) {
            return UIColor.init(named: "woloxTabBarBackgroundColor") ?? UIColor(red: 252, green: 254, blue: 254, alpha: 1.0)
        } else {
            return UIColor(red: 252, green: 252, blue: 254, alpha: 1.0)
        }
    }
}
