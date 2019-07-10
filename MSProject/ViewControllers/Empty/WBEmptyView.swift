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
        emptyTitleLabel.textColor = .woloxBackgroundColor()
        emptyTitleDescription.text = ""
        emptyTitleDescription.textColor = .woloxBackgroundColor()
    }
    
    func configureEmptyWishlist() {
        emptyTitleLabel.text = "WISHLIST_EMPTY_TITLE".localized()
        emptyTitleDescription.text = "WISHLIST_EMPTY_DESCRIPTION".localized()
        sadImage.image = UIImage.wishlistActiveImage
        refreshButton.isHidden = true
    }
    
    func configureEmptyRents() {
        emptyTitleLabel.text = "RENTS_EMPTY".localized()
        emptyTitleDescription.text = "RENTS_EMPTY_DESCRIPTION".localized()
        sadImage.image = UIImage.rentalsActiveImage
        refreshButton.isHidden = true
    }
}
