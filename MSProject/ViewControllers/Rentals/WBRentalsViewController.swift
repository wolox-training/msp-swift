//
//  WBRentalsViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBRentalsViewController: UIViewController {

    private let rentalsView: WBRentalsView = WBRentalsView.loadFromNib()!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RENTALS".localized()
    }
    
    override func loadView() {
        view = rentalsView
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
