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
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFromNib()!

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

        title = "BOOK_DETAIL_NAV_BAR".localized()
        setBackButtonEmpty()
        
        configureTableView()
        
        initBookDetailTableViewModel()
    }
    
    override func loadView() {
        _detailHeaderView.configureUI()
        _detailHeaderView.setup(with: bookViewModel)
        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {

        // Rent Book
        viewModel.rentBookAction.values.observeValues { [unowned self] _ in
            self.showAlert(message: "BOOK_RENTED".localized())
            self.bookViewModel.rented = true
            self._detailHeaderView.setup(with: self.bookViewModel)
            self.viewModel.bookAvailable.value = false
        }
        
        viewModel.rentBookAction.errors.observeValues { [unowned self] error in
            self.showAlert(message: error.localizedDescription)
        }
        
        viewModel.rentBookAction.isExecuting.signal.observeValues { [unowned self] isExecuting in
            if isExecuting {
                MBProgressHUD.showAdded(to: self._view, animated: true)
            } else {
                MBProgressHUD.hide(for: self._view, animated: true)
            }
        }
        
        viewModel.rentBookAction.isEnabled.signal.observeValues { [unowned self] _ in
            self._detailHeaderView.setup(with: self.bookViewModel)
        }

        viewModel.bookAvailable.value = bookViewModel.bookStatus.isBookAvailable()
        
        _detailHeaderView.rentButton?.reactive.pressed = CocoaAction(viewModel.rentBookAction, input: bookViewModel.book)

        // Wish Book
        _detailHeaderView.wishlistButton?.reactive.controlEvents(.touchUpInside)
            .observeValues { _ in
            
                guard !self.bookViewModel.rented else {
                    let commentBookViewController = WBCommentViewController(with: self.bookViewModel)
                    self.navigationController?.pushViewController(commentBookViewController, animated: true)
                    return
                }

                guard !self.bookViewModel.wished else {
                    self.showAlert(message: "Unwish not implemented yet...")
                    return
                }
                
                MBProgressHUD.showAdded(to: self._view, animated: true)

                self.viewModel.wishBook(book: self.bookViewModel.book).startWithResult { [unowned self] result in
                    switch result {
                    case .success:
                        self.bookViewModel.wished = true
                        self._detailHeaderView.setup(with: self.bookViewModel)
                    case .failure(let error):
                        self.showAlert(message: error.localizedDescription)
                    }
                    MBProgressHUD.hide(for: self._view, animated: true)
                }
        }
        
        loadComments()
        loadSuggestions()
    }
    
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        
        let commentBookNib = UINib.init(nibName: "WBCommentsBookTableViewCell", bundle: nil)
        _view.detailTable.register(commentBookNib, forCellReuseIdentifier: "WBCommentsBookTableViewCell")
        let suggestionNib = UINib.init(nibName: "WBSuggestionsTableViewCell", bundle: nil)
        _view.detailTable.register(suggestionNib, forCellReuseIdentifier: "WBSuggestionsTableViewCell")
        
        _view.configureDetailTableView()
    }
    
    private func loadComments() {
        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.loadComments(book: bookViewModel.book).startWithResult { [unowned self] result in
            switch result {
            case .success:
                self._view.detailTable.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            MBProgressHUD.hide(for: self._view, animated: true)
        }
    }
    
    private func loadSuggestions() {
        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.loadSuggestions(book: bookViewModel.book).startWithResult { [unowned self] result in
            switch result {
            case .success:
                self._view.detailTable.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            MBProgressHUD.hide(for: self._view, animated: true)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension WBDetailBookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBSuggestionsTableViewCell", for: indexPath) as? WBSuggestionsTableViewCell else {
                fatalError("Cell not exists")
            }
            
            let suggestions = viewModel.getSuggestionsBookViewModel()
            cell.setup(with: suggestions)
            return cell
        } else {
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

// MARK: - Actions
extension WBDetailBookViewController {
//    func rentBook() {
//        guard bookViewModel.bookStatus == .available else {
//            showAlertMessage(message: "RENT_NOT_AVAILABLE".localized(withArguments: bookViewModel.bookStatus.bookStatusText()))
//            return
//        }
//        MBProgressHUD.showAdded(to: _view, animated: true)
//        bookDetailViewModel.rentBook(book: bookViewModel)
//    }
}
