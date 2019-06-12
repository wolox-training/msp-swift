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

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLibraryTableViewModel()
        
        configureTableView()
        
        navigationItem.title = "LIBRARY".localized() + " Table"
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookTable.refreshControl = refreshControl
        
    }

    // MARK: - Private
    private func initLibraryTableViewModel() {
        libraryViewModel.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?._view.bookTable.reloadData()
            }
        }
        
        libraryViewModel.loadBooks()
    }
    
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        _view.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self._view.bookTable.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return libraryViewModel.heightOfCells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let cellViewModel = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookCellViewModel = cellViewModel
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBLibraryTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        libraryViewModel.selectBook(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
