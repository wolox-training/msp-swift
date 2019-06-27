//
//  UIColorExtension.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func woloxBackgroundColor() -> UIColor {
        if #available(iOS 11.0, *), let color = UIColor(named: "woloxBackgroundColor") {
            return color
        } else {
            return UIColor(red: 0.0, green: 0.68, blue: 0.93, alpha: 1.0)
        }
    }
    
    class func woloxBackgroundLightColor() -> UIColor {
        if #available(iOS 11.0, *), let color = UIColor(named: "woloxBackgroundLightColor") {
            return color
        } else {
            return UIColor(red: 231, green: 245, blue: 249, alpha: 1.0)
        }
    }
    
    class func woloxTabBarBackgroundColor() -> UIColor {
        if #available(iOS 11.0, *), let color = UIColor(named: "woloxTabBarBackgroundColor") {
            return color
        } else {
            return UIColor(red: 252, green: 252, blue: 254, alpha: 1.0)
        }
    }
    
    public static var woloxRedColor: UIColor {
        return UIColor(red: 0.82, green: 0.01, blue: 0.11, alpha: 1)
    }

    public static var woloxGreenColor: UIColor {
        return UIColor(red: 0.65, green: 0.8, blue: 0.22, alpha: 1)
    }
    
}
