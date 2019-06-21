//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import MBProgressHUD

class WBLibraryTableViewController: UIViewController {

    private let _view: WBLibraryTableView = WBLibraryTableView.loadFromNib()!

    lazy var viewModel: WBLibraryViewModel = {
        return WBLibraryViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: nil))
    }()
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        title = "LIBRARY_NAV_BAR".localized()
        
        let sort = UIBarButtonItem(image: UIImage.sortImage, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let search = UIBarButtonItem(image: UIImage.searchImage, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [sort, search]
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookTable.refreshControl = refreshControl
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBooks()
    }
    
    // MARK: - Private
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        _view.bookTable.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
        
        _view.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.repository.getBooks().startWithResult { [unowned self] result in
            switch result {
            case .success(let value):
                self._view.bookTable.refreshControl?.endRefreshing()
                MBProgressHUD.hide(for: self._view, animated: true)
                self.loadTableWithBooks(books: value)
            case .failure(let error):
                self._view.bookTable.refreshControl?.endRefreshing()
                MBProgressHUD.hide(for: self._view, animated: true)
                self.showAlertMessage(message: error.localizedDescription)
            }
        }
    }
    
    private func loadTableWithBooks(books: [WBBook]) {
        viewModel.libraryItems = books
        viewModel.sortBooks()
        _view.bookTable.reloadData()
    }
}

extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let book = viewModel.getCellViewModel(at: indexPath)
        cell.bookImage.loadImageUsingCache(withUrl: book.bookImageURL, placeholderImage: UIImage.placeholderBookImage)

        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        return cell
    }
    
}

extension WBLibraryTableViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.selectBook(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController(with: book)
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
    
}
