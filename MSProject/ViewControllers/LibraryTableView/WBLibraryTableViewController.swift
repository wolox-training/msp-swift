//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

import CoreSpotlight
import MobileCoreServices

class WBLibraryTableViewController: UIViewController {

    private let _view: WBLibraryTableView = WBLibraryTableView.loadFromNib()!
    lazy private var emptyView: WBEmptyView = WBEmptyView.loadFromNib()!
    lazy private var searchView: WBSearchView = WBSearchView.loadFromNib()!

    lazy var viewModel: WBLibraryViewModel = {
        return WBLibraryViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()

    let searchController = UISearchController(searchResultsController: nil)
    var refreshControl: UIRefreshControl?

    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        title = "LIBRARY_NAV_BAR".localized()
        
        let sort = UIBarButtonItem(image: UIImage.sortImage, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let search = UIBarButtonItem(image: UIImage.searchImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchBook))
        setNavigationRightButtons([sort, search])
        
        initRefreshControl()
        
        // Search Control
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        searchController.searchBar.tintColor = .woloxBackgroundColor()
        searchController.searchBar.barTintColor = .woloxBackgroundColor()
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
  
        emptyView.refreshButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.loadBooks()
        }
        
        viewModel.state.signal.observeValues { state in
            switch state {
            case .loading:
                self.view = self._view
                MBProgressHUD.showAdded(to: self._view, animated: true)
            case .value:
                self._view.bookTable.reloadData()
                MBProgressHUD.hide(for: self._view, animated: true)
            case .error:
                self.view = self.emptyView
                MBProgressHUD.hide(for: self._view, animated: true)
            case .empty:
                self.view = self.emptyView
                MBProgressHUD.hide(for: self._view, animated: true)
            }
            self._view.bookTable.refreshControl?.endRefreshing()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBooks()
    }
    
    // MARK: - Search
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        isFiltering()
        viewModel.filterBooks(with: searchText)
        _view.bookTable.reloadData()
    }
    
    func isFiltering() {
        if searchBarIsEmpty() {
            if !_view.subviews.contains(searchView) {
                searchView.frame = _view.frame
                _view.addSubview(searchView)
            }
        } else {
            if _view.subviews.contains(searchView) {
                searchView.removeFromSuperview()
            }
        }
        viewModel.isFiltering = searchController.isActive && (!searchBarIsEmpty())
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
        viewModel.state.value = ViewState.loading
        viewModel.loadBooks().startWithResult { [unowned self] result in
            switch result {
            case .success(let value):
                self.viewModel.state.value = value.isEmpty ? ViewState.empty : ViewState.value
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
                self.viewModel.state.value = ViewState.error
            }
        }
//        viewModel.bookViewModels.signal.observeValues { (_) in
//            self._view.bookTable.reloadData()
//        }
    }
            
    @objc private func searchBook() {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            _view.bookTable.tableHeaderView = searchController.searchBar
        }
        searchController.searchBar.becomeFirstResponder()

    }
    
    private func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl?.tintColor = .woloxBackgroundColor()
        _view.bookTable.refreshControl = refreshControl
    }
    
    // MARK: - Spotlight
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType, let info = activity.userInfo, let selectedIdentifier = info[CSSearchableItemActivityIdentifier] as? String {
            if let book = viewModel.getBookById(id: selectedIdentifier) {
                let detailBookViewController = WBDetailBookViewController(with: book)
                navigationController?.popToRootViewController(animated: true)
                navigationController?.pushViewController(detailBookViewController, animated: true)
            }
        }
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
        cell.setup(with: book)
        return cell
    }
    
}

extension WBLibraryTableViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.getCellViewModel(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController(with: book)
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
}

extension WBLibraryTableViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        refreshControl = nil
        _view.bookTable.refreshControl = nil
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        initRefreshControl()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if _view.subviews.contains(searchView) {
            searchView.removeFromSuperview()
        }
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = nil
        } else {
            self._view.bookTable.tableHeaderView = nil
        }
    }
}

extension WBLibraryTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension WBLibraryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}
