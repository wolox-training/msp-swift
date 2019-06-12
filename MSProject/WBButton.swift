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
    
    // status disabled
        // bakcground color = lightgray
        // title color = white
        // border line color = lightgray
}
