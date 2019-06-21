//
//  UIViewControllerExtension.swift
//  MSProject
//
//  Created by Matias Spinelli on 21/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertMessage(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
