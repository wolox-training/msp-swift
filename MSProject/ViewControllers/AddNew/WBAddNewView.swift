//
//  WBAddNewView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

enum TextFieldTag: Int, CaseIterable {
    case name = 30
    case author
    case year
    case topic
    case description
}

class WBAddNewView: UIView, NibLoadable {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var nameTextField: WBTextField! {
        didSet {
            nameTextField.placeholder = "NAME_BOOK_PLACEHOLDER".localized()
            nameTextField.delegate = self
            nameTextField.returnKeyType = .next
            nameTextField.wbTextFieldProtocol = self
            nameTextField.tag = TextFieldTag.name.rawValue
        }
    }
    
    @IBOutlet weak var authorTextField: WBTextField! {
        didSet {
            authorTextField.placeholder = "AUTHOR_PLACEHOLDER".localized()
            authorTextField.delegate = self
            authorTextField.returnKeyType = .next
            authorTextField.wbTextFieldProtocol = self
            authorTextField.tag = TextFieldTag.author.rawValue
        }
    }
    
    @IBOutlet weak var yearTextField: WBTextField! {
        didSet {
            yearTextField.placeholder = "YEAR_PLACEHOLDER".localized()
            yearTextField.delegate = self
            yearTextField.returnKeyType = .next
            yearTextField.keyboardType = .numberPad
            yearTextField.wbTextFieldProtocol = self
            yearTextField.tag = TextFieldTag.year.rawValue
        }
    }
    
    @IBOutlet weak var topicTextField: WBTextField! {
        didSet {
            topicTextField.placeholder = "TOPIC_PLACEHOLDER".localized()
            topicTextField.delegate = self
            topicTextField.returnKeyType = .next
            topicTextField.wbTextFieldProtocol = self
            topicTextField.tag = TextFieldTag.topic.rawValue
        }
    }
    
    @IBOutlet weak var descriptionTextField: WBTextField! {
        didSet {
            descriptionTextField.placeholder = "DESCRIPTION_PLACEHOLDER".localized()
            descriptionTextField.delegate = self
            descriptionTextField.returnKeyType = .done
            descriptionTextField.wbTextFieldProtocol = self
            descriptionTextField.tag = TextFieldTag.description.rawValue
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
    
    @objc func cancelNumberPad() {
        yearTextField.resignFirstResponder()
    }
    
    @objc func doneWithNumberPad() {
        yearTextField.resignFirstResponder()
    }
}

extension WBAddNewView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollRectToVisible(textField.frame, animated: true)
        if textField.tag == TextFieldTag.name.rawValue {
            (textField as? WBTextField)?.previousButton.isEnabled = false
        } else {
            (textField as? WBTextField)?.previousButton.isEnabled = true
        }
        if textField.tag == TextFieldTag.description.rawValue {
            (textField as? WBTextField)?.nextButton.isEnabled = false
        } else {
            (textField as? WBTextField)?.nextButton.isEnabled = true
        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == TextFieldTag.year.rawValue && textField.text?.count == 4 {
            return false
        }
        return true
    }
}

extension WBAddNewView: WBTextFieldProtocol {
    func goPreviousTextField(textField: UITextField) {
        self.scrollToTextField(tag: textField.tag - 1)
        textField.resignFirstResponder()
    }
    
    func goNextTextField(textField: UITextField) {
        self.scrollToTextField(tag: textField.tag + 1)
        textField.resignFirstResponder()
    }
    
    private func scrollToTextField(tag: Int) {
        let nextResponder = self.viewWithTag(tag) as UIResponder?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        }
    }
}
