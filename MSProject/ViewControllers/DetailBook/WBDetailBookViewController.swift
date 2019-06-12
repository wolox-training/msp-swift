//
//  WBDetailBookViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBDetailBookViewController: UIViewController {

    private let detailBookView: WBDetailBookView = WBDetailBookView.loadFromNib()!

    var bookView: WBBookCellViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = bookView.bookTitle

//        detailBookView.bookImageView.image = bookView.bookImageURL
        
        configureTableView()
    }
    
    override func loadView() {
        view = detailBookView
    }

    // MARK: - Private
    private func configureTableView() {
//        detailBookView.detailTableView.delegate = self
//        detailBookView.detailTableView.dataSource = self
        
        detailBookView.configureDetailTableView()
    }
}
