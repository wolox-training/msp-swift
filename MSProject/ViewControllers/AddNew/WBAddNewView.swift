//
//  WBAddNewView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBAddNewView: UIView, NibLoadable {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.placeholder = "NAME_BOOK_PLACEHOLDER".localized()
            nameTextField.delegate = self
            nameTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var authorTextField: UITextField! {
        didSet {
            authorTextField.placeholder = "AUTHOR_PLACEHOLDER".localized()
            authorTextField.delegate = self
            authorTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var yearTextField: UITextField! {
        didSet {
            yearTextField.placeholder = "YEAR_PLACEHOLDER".localized()
            yearTextField.delegate = self
            yearTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var topicTextField: UITextField! {
        didSet {
            topicTextField.placeholder = "TOPIC_PLACEHOLDER".localized()
            topicTextField.delegate = self
            topicTextField.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.placeholder = "DESCRIPTION_PLACEHOLDER".localized()
            descriptionTextField.delegate = self
            descriptionTextField.returnKeyType = .done
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
            customBackgroundView.layer.cornerRadius = 5
            customBackgroundView.backgroundColor = .white
        }
    }

    func configureDetailTableView() {
        
        backgroundColor = .woloxBackgroundLightColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func reloadViewAsEmpty() {
        addImageButton.setImage(UIImage.addPhotoImage, for: .normal)
        nameTextField.text = ""
        authorTextField.text = ""
        yearTextField.text = ""
        topicTextField.text = ""
        descriptionTextField.text = ""
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        if let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset: UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            scrollView.contentInset = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
}

extension WBAddNewView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollRectToVisible(textField.frame, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
