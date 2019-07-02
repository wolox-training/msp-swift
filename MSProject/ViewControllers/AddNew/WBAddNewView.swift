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

    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var submitButton: WBButton!
    
    @IBOutlet private weak var customBackgroundView: UIView!

    func configureDetailTableView() {
        
        backgroundColor = .woloxBackgroundLightColor()
        
        customBackgroundView.layer.cornerRadius = 5
        customBackgroundView.backgroundColor = .white

        submitButton.setTitle("SUBMIT_BUTTON".localized(), for: .normal)
        submitButton.buttonStyle = .filled
        
        nameTextField.placeholder = "NAME_BOOK_PLACEHOLDER".localized()
        authorTextField.placeholder = "AUTHOR_PLACEHOLDER".localized()
        yearTextField.placeholder = "YEAR_PLACEHOLDER".localized()
        topicTextField.placeholder = "TOPIC_PLACEHOLDER".localized()
        descriptionTextField.placeholder = "DESCRIPTION_PLACEHOLDER".localized()
        
        nameTextField.delegate = self
        authorTextField.delegate = self
        yearTextField.delegate = self
        topicTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameTextField.returnKeyType = .next
        authorTextField.returnKeyType = .next
        yearTextField.returnKeyType = .next
        topicTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done

    }
    
    func reloadViewAsEmpty() {
        addImageButton.setImage(UIImage.addPhotoImage, for: .normal)
        nameTextField.text = ""
        authorTextField.text = ""
        yearTextField.text = ""
        topicTextField.text = ""
        descriptionTextField.text = ""
    }
}

extension WBAddNewView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
