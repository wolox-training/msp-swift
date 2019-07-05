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
    
    @IBOutlet weak var sadImage: UIImageView! {
        didSet {
            sadImage.image = sadImage.image?.withRenderingMode(.alwaysTemplate)
            sadImage.tintColor = .woloxBackgroundColor()
        }
    }
    
    @IBOutlet weak var emptyTitleLabel: UILabel!
    
    @IBOutlet weak var emptyTitleDescription: UILabel!
    
    @IBOutlet weak var refreshButton: WBButton! {
        didSet {
            refreshButton.borderLineColor = .woloxBackgroundColor()
            refreshButton.buttonStyle = .bordered
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        emptyTitleLabel.text = ""
        emptyTitleDescription.text = ""
    }
    
    func configureEmptyWishlist() {
        
        sadImage.image = UIImage.wishlistActiveImage
        refreshButton.isHidden = true
    }
    
    func configureEmptyRents() {
        
        sadImage.image = UIImage.rentalsActiveImage
        refreshButton.isHidden = true
    }
}
