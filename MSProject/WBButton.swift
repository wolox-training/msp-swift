//
//  WBButton.swift
//  BaseProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

@IBDesignable
class WBButton: UIButton {

    // MARK: Inspectables
    @IBInspectable var borderLineWidth: CGFloat = 1.5 {
        didSet {
            layer.borderWidth = borderLineWidth
        }
    }
    
    @IBInspectable var borderLineColor: UIColor = .white {
       didSet {
            layer.borderColor = borderLineColor.cgColor
        }
    }

    @IBInspectable var borderLineRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = borderLineRadius
        }
    }
    
    // if disable the button, lost the user interaction
    @IBInspectable var enabledButton: Bool = true {
        didSet {
            if self.enabledButton == false {
                backgroundColor = .lightGray
                setTitleColor(.white, for: UIControlState.normal)
                borderLineColor = .lightGray
            }
        }
    }
    
}
