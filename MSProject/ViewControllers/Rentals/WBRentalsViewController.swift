//
//  WBRentalsViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 10/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

class WBRentalsViewController: UIViewController {

    private let _view: WBRentalsView = WBRentalsView.loadFromNib()!

    lazy private var emptyView: WBEmptyView = WBEmptyView.loadFromNib()!

    lazy var viewModel: WBRentalsViewModel = {
        return WBRentalsViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureTableView()
        loadRents()
        loadSuggestions()

        navigationItem.title = "RENTALS_NAV_BAR".localized()
        setBackButtonEmpty()
        
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
        }
        
        WBBooksManager.sharedIntance.rentedBooks.signal.observeValues { (rentedBooks) in
            self.viewModel.state.value = rentedBooks.isEmpty ? .empty : .value
        }
        
    }
    
    override func loadView() {
        emptyView.configureEmptyRents()
        view = _view
    }
    
    // MARK: - Private
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        let nib = UINib(nibName: "WBBookTableViewCell", bundle: nil)
        _view.bookTable.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
        let suggestionNib = UINib(nibName: "WBSuggestionsTableViewCell", bundle: nil)
        _view.bookTable.register(suggestionNib, forCellReuseIdentifier: "WBSuggestionsTableViewCell")
    }
    
    private func loadRents() {
        self._view.bookTable.reloadData()
    }
    
    private func loadSuggestions() {
        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.loadSuggestions().take(during: self.reactive.lifetime).startWithResult { [unowned self] result in
            switch result {
            case .success:
                self._view.bookTable.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            MBProgressHUD.hide(for: self._view, animated: true)
        }
    }
    
}

extension WBRentalsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
                fatalError("Cell not exists")
            }
            
            let book = viewModel.getCellViewModel(at: indexPath)
            cell.setup(with: book)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBSuggestionsTableViewCell", for: indexPath) as? WBSuggestionsTableViewCell else {
                fatalError("Cell not exists")
            }
            
            let suggestions = viewModel.getSuggestionsBookViewModel()
            cell.setup(with: suggestions)
            return cell
        }
    }
    
}

extension WBRentalsViewController: UITableViewDelegate {
    
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
