//
//  WBCommentView.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBCommentView: UIView, NibLoadable {
    
    @IBOutlet weak var detailHeaderView: WBDetailBookHeaderView!
    @IBOutlet weak var commentTextView: UITextView! {
        didSet {
            commentTextView.layer.borderColor = UIColor.lightGray.cgColor
            commentTextView.layer.borderWidth = 1.0            
            commentTextView.delegate = self
        }
    }
    @IBOutlet weak var commentPlaceholder: UILabel! {
        didSet {
            commentPlaceholder.text = "WRITE_COMMENT_PLACEHOLDER".localized()
        }
    }
    
    @IBOutlet weak var submitButton: WBButton! {
        didSet {
            submitButton.setTitle("SUBMIT_BUTTON".localized(), for: .normal)
            submitButton.buttonStyle = .filled
        }
    }
    
    @IBOutlet private weak var customBackgroundView: UIView! {
        didSet {
            customBackgroundView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var commentBackgroundView: UIView! {
        didSet {
            commentBackgroundView.layer.cornerRadius = 5
            commentBackgroundView.backgroundColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .woloxBackgroundLightColor()
    }
}

extension WBCommentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentPlaceholder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            commentPlaceholder.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textView.resignFirstResponder()
        return false
    }
}
