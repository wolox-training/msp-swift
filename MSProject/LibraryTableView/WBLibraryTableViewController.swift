//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBLibraryTableViewController: UIViewController {

    private let _view: WBLibraryTableView = WBLibraryTableView.loadFromNib()!
    var libraryItems: [WBBook] = []

    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        loadBooks()
        
        title = "LIBRARY".localized() + "Table"
        
//        let grid = UIBarButtonItem(image: UIImage(named: "grid"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(gridMode))
//        navigationItem.rightBarButtonItem = grid
        
    }

    /*@objc func gridMode() {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.view.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                if self.view.isKind(of: WBLibraryTableView.self) {
                    self.view = self.libraryCollectionView
                    self.libraryCollectionView.libraryCollectionView.reloadData()
                } else {
                    self.view = self.libraryTableView
                    self.libraryTableView.libraryTableView.reloadData()
                }
                self.view.alpha = 1.0
            }, completion: nil)
        }
    }*/
    
    // MARK: - Private
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        _view.bookTable.backgroundColor = .woloxBackgroundLightColor()
        _view.bookTable.separatorStyle = .none
        
        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        _view.bookTable.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
    }
    
    // MARK: - Services
    private func loadBooks() {
        libraryItems = WBBookDAO.sharedInstance.getAllBooks()
        _view.bookTable.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0+10.0 //le agrego 10 porque es lo que le quita el contentview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WBBookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as! WBBookTableViewCell // swiftlint:disable:this force_cast
        
        let book: WBBook = libraryItems[indexPath.row]
        
        cell.bookImage.image = UIImage(named: book.bookImageURL ?? "placeholder_image")
        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBLibraryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book: WBBook = libraryItems[indexPath.row]
        print("\(book.bookTitle ?? "") \(book.bookAuthor ?? "")")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
