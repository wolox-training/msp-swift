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

        title = "BOOK_DETAIL".localized()

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

        viewModel.rentBookAction.values.observeValues { [unowned self] _ in
            self.showAlert(message: "BOOK_RENTED".localized())
            // trampita para actualizar la vista segun el book view model
            if let bookViewModel = self.bookViewModel {
                let bookRented = WBBook(id: bookViewModel.book.id,
                                        title: bookViewModel.book.title,
                                        author: bookViewModel.book.author,
                                        status: BookStatus.rented.rawValue,
                                        genre: bookViewModel.book.genre,
                                        year: bookViewModel.book.year,
                                        imageURL: bookViewModel.book.imageURL)
                self.bookViewModel = WBBookViewModel(book: bookRented)
                self._detailHeaderView.setup(with: self.bookViewModel)
            }

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
        
        _detailHeaderView.rentButton.reactive.pressed = CocoaAction(viewModel.rentBookAction, input: bookViewModel.book)
        
        _detailHeaderView.wishlistButton.reactive.controlEvents(.touchUpInside)
            .observeValues { _ in
            self.addToWishlist()
        }
        
        loadComments()
    }
    
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        
        let commentBookNib = UINib.init(nibName: "WBCommentsBookTableViewCell", bundle: nil)
        _view.detailTable.register(commentBookNib, forCellReuseIdentifier: "WBCommentsBookTableViewCell")
        
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
}

// MARK: - UITableViewDataSource
extension WBDetailBookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBCommentsBookTableViewCell", for: indexPath) as? WBCommentsBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let comment = viewModel.getCellViewModel(at: indexPath)
        cell.setup(with: comment)
        return cell
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
    func addToWishlist() {
        
    }
    
//    func rentBook() {
//        guard bookViewModel.bookStatus == .available else {
//            showAlertMessage(message: "RENT_NOT_AVAILABLE".localized(withArguments: bookViewModel.bookStatus.bookStatusText()))
//            return
//        }
//        MBProgressHUD.showAdded(to: _view, animated: true)
//        bookDetailViewModel.rentBook(book: bookViewModel)
//    }
}
