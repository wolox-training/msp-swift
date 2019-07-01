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
    }
}
