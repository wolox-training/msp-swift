//
//  UIViewControllerExtension.swift
//  MSProject
//
//  Created by Matias Spinelli on 21/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

extension UIViewController {
    func showAlertMessage(message: String) {
        presentAlert(ErrorAlertViewModel(title: "", message: message, dismissButtonTitle: "OK", dismissAction: { (_) in
            
        }))
    }
}
