//
//  WBEmptyView.swift
//  MSProject
//
//  Created by Matias Spinelli on 24/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

public enum ViewState {
    case loading
    case value
    case error
    case empty
}

class WBEmptyView: UIView, NibLoadable {
    
    @IBOutlet weak var sadImage: UIImageView!
    @IBOutlet weak var refreshButton: WBButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        refreshButton.borderLineColor = .woloxBackgroundColor()
        refreshButton.buttonStyle = .bordered
    
        sadImage.image = sadImage.image?.withRenderingMode(.alwaysTemplate)
        sadImage.tintColor = .woloxBackgroundColor()
    }
    
}
