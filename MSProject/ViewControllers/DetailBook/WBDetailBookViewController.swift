//
//  WBDetailBookViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import ReactiveCocoa
import ReactiveSwift
import MBProgressHUD

class WBDetailBookViewController: UIViewController {

    private let _view: WBDetailBookView = WBDetailBookView.loadFromNib()!

    lazy var viewModel: WBBookDetailViewModel = {
        return WBBookDetailViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()
    
    var bookViewModel: WBBookViewModel!
    
    convenience init(with bookViewModel: WBBookViewModel) {
        self.init()
        self.bookViewModel = bookViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "BOOK_DETAIL_NAV_BAR".localized()
        setBackButtonEmpty()
        
        configureTableView()
        
        initBookDetailTableViewModel()
    }
    
    override func loadView() {
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {
        
        // Rent Action Book
        viewModel.rentBookAction.values.observeValues { [unowned self] _ in
            self.showAlert(message: "BOOK_RENTED".localized())
            self.bookViewModel.rented = true
            self._view.detailTable.reloadData()
        }
        
        viewModel.rentBookAction.errors.observeValues { [unowned self] error in
            guard !self.bookViewModel.rented else {
                self.showAlert(message: "RETURN_BOOK_NOT_IMPLEMENTED".localized())
                return
            }
            guard self.bookViewModel.bookStatus == .available else {
                self.showAlert(message: "RENT_NOT_AVAILABLE".localized(withArguments: self.bookViewModel.bookStatus.bookStatusText()))
                return
            }
            self.showAlert(message: error.localizedDescription)
        }
        
        viewModel.rentBookAction.isExecuting.signal.observeValues { [unowned self] isExecuting in
            if isExecuting {
                MBProgressHUD.showAdded(to: self._view, animated: true)
            } else {
                MBProgressHUD.hide(for: self._view, animated: true)
            }
        }

        // Wish Action Book
        viewModel.wishBookAction.values.observeValues { [unowned self] _ in
            self.bookViewModel.wished = true
            self._view.detailTable.reloadData()
        }
        
        viewModel.wishBookAction.errors.observeValues { [unowned self] error in
            guard !self.bookViewModel.rented else {
                let commentBookViewController = WBCommentViewController(with: self.bookViewModel)
                self.navigationController?.pushViewController(commentBookViewController, animated: true)
                return
            }
            guard !self.bookViewModel.wished else {
                self.showAlert(message: "REMOVE_FROM_WISHLIST_NOT_IMPLEMENTED".localized())
                return
            }
            self.showAlert(message: error.localizedDescription)
        }
        
        viewModel.wishBookAction.isExecuting.signal.observeValues { [unowned self] isExecuting in
            if isExecuting {
                MBProgressHUD.showAdded(to: self._view, animated: true)
            } else {
                MBProgressHUD.hide(for: self._view, animated: true)
            }
        }

        // merge
        

        loadComments()
        loadSuggestions()
    }
    
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        _view.detailTable.estimatedSectionHeaderHeight = 25

        let detailNib = UINib(nibName: "WBDetailBookTableViewCell", bundle: nil)
        _view.detailTable.register(detailNib, forCellReuseIdentifier: "WBDetailBookTableViewCell")
        
        let commentBookNib = UINib(nibName: "WBCommentsBookTableViewCell", bundle: nil)
        _view.detailTable.register(commentBookNib, forCellReuseIdentifier: "WBCommentsBookTableViewCell")
        let suggestionNib = UINib(nibName: "WBSuggestionsTableViewCell", bundle: nil)
        _view.detailTable.register(suggestionNib, forCellReuseIdentifier: "WBSuggestionsTableViewCell")
    }
    
    private func loadComments() {
//        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.loadComments(book: bookViewModel.book).startWithResult { [unowned self] result in
            switch result {
            case .success:
                self._view.detailTable.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func loadSuggestions() {
        viewModel.loadSuggestions(book: bookViewModel.book).startWithResult { [unowned self] result in
            switch result {
            case .success:
                self._view.detailTable.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
//            MBProgressHUD.hide(for: self._view, animated: true)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension WBDetailBookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(for: BookDetailSections(rawValue: section)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch BookDetailSections(rawValue: indexPath.section)! {
        case .bookDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBDetailBookTableViewCell", for: indexPath) as? WBDetailBookTableViewCell else {
                fatalError("Cell not exists")
            }
            
            cell.setup(with: bookViewModel)
            cell.rentButton?.reactive.pressed = CocoaAction(viewModel.rentBookAction, input: bookViewModel)
            cell.wishlistButton?.reactive.pressed = CocoaAction(viewModel.wishBookAction, input: bookViewModel)
            return cell
        case .suggestions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBSuggestionsTableViewCell", for: indexPath) as? WBSuggestionsTableViewCell else {
                fatalError("Cell not exists")
            }
            
            let suggestions = viewModel.getSuggestionsBookViewModel()
            cell.setup(with: suggestions)
            return cell
        case .comments:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBCommentsBookTableViewCell", for: indexPath) as? WBCommentsBookTableViewCell else {
                fatalError("Cell not exists")
            }
            
            let comment = viewModel.getCommentViewModel(at: indexPath)
            cell.setup(with: comment)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension WBDetailBookViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
