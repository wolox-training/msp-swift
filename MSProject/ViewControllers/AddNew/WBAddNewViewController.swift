//
//  WBAddNewViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBAddNewViewController: UIViewController {

    private let addNewView: WBAddNewView = WBAddNewView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ADDNEW".localized()
    }
    
    override func loadView() {
        view = addNewView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
