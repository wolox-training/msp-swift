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
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentPlaceholder: UILabel!
    @IBOutlet weak var submitButton: WBButton!
    
    func configureDetailTableView() {
        
        backgroundColor = .woloxBackgroundLightColor()
        
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.delegate = self
        
        submitButton.setTitle("SUBMIT_BUTTON".localized(), for: .normal)
        submitButton.buttonStyle = .filled
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
