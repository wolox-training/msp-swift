//
//  WBLoginView.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import Foundation
import UIKit
import WolmoCore

class WBLoginView: UIView, NibLoadable {
    
    weak var delegate: WBLoginViewController?
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        delegate?.loginWithGoogle(sender)
    }
}
