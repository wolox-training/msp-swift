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

    private let _view: WBDetailBookView = WBDetailBookView.loadFromNib()!

    var bookView: WBBookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = bookView.bookTitle

        _view.bookImageView.loadImageUsingCache(withUrl: bookView.bookImageURL)
        
        configureTableView()
    }
    
    override func loadView() {
        view = _view
    }

    // MARK: - Private
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        
        _view.configureDetailTableView()
    }
}

// MARK: - UITableViewDataSource
extension WBDetailBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 264.0+10.0 //le agrego 10 porque es lo que le quita el contentview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBDetailBookTableViewCell", for: indexPath) as? WBDetailBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        cell.delegate = self
        cell.bookCellViewModel = bookView
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBDetailBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - DetailBookDelegate
extension WBDetailBookViewController: DetailBookDelegate {
    func addToWishlist() {
        
    }
    
    func rentBook() {
        WBBookDAO.sharedInstance.rentBook(book: bookView.book)
    }
    
}
