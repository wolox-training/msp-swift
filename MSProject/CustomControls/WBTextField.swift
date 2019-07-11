//
//  WBTextField.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/07/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

protocol WBTextFieldProtocol {
    func goPreviousTextField(textField: UITextField)
    func goNextTextField(textField: UITextField)
}

class WBTextField: UITextField {
    
    let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_previous"), style: .plain, target: self, action: #selector(goPreviousTextField))

    let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_next"), style: .plain, target: self, action: #selector(goNextTextField))
    
    var wbTextFieldProtocol: WBTextFieldProtocol?
    
    override func awakeFromNib() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.tintColor = .woloxBackgroundColor()
        toolbar.items = [
            previousButton,
            nextButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTextField))]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
}

extension WBTextField: WBTextFieldProtocol {
    @objc func goPreviousTextField(textField: UITextField) {
        wbTextFieldProtocol?.goPreviousTextField(textField: self)
    }
    
    @objc func goNextTextField(textField: UITextField) {
        wbTextFieldProtocol?.goNextTextField(textField: self)
    }
    
    @objc func doneTextField(textField: UITextField) {
        self.resignFirstResponder()
    }
}

