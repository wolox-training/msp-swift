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
        return WBBookDetailViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: nil))
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
        _detailHeaderView.setup(with: bookViewModel)
        _detailHeaderView.configureUI()
        
        _detailHeaderView.rentButton.setTitle("RENT_BOOK_BUTTON".localized(), for: .normal)
        _detailHeaderView.wishlistButton.setTitle("WISHLIST_ADD_BUTTON".localized(), for: .normal)

        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {

        viewModel.rentBookAction.values.observeValues { [unowned self] _ in
            MBProgressHUD.hide(for: self._view, animated: true)
            self.showAlertMessage(message: "BOOK_RENTED".localized())
            self.viewModel.bookAvailable.value = false
        }
        
        viewModel.rentBookAction.errors.observeValues { [unowned self] error in
            MBProgressHUD.hide(for: self._view, animated: true)
            self.showAlertMessage(message: error.localizedDescription)
        }
        
        viewModel.rentBookAction.isExecuting.signal.observeValues { [unowned self] isExecuting in
            if isExecuting {
                MBProgressHUD.showAdded(to: self._view, animated: true)
            }
        }
        
        viewModel.rentBookAction.isEnabled.signal.observeValues { [unowned self] isEnabled in
            if isEnabled {
                self._detailHeaderView.bookAvailable.textColor = .green
                self._detailHeaderView.rentButton.buttonStyle = .filled
            } else {
                self._detailHeaderView.bookAvailable.textColor = .red
                self._detailHeaderView.rentButton.buttonStyle = .disabled
            }
        }

        viewModel.bookAvailable.value = bookViewModel.bookStatus.isBookAvailable()
        
        _detailHeaderView.rentButton.reactive.pressed = CocoaAction(viewModel.rentBookAction, input: bookViewModel.book)
        
        _detailHeaderView.wishlistButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.addToWishlist()
        }
        
        loadComments()
    }
    
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        
        _view.configureDetailTableView()
    }
    
    private func loadComments() {
        MBProgressHUD.showAdded(to: _view, animated: true)
        viewModel.repository.getBookComments(book: bookViewModel.book).startWithResult { [unowned self] result in
            switch result {
            case .success(let value):
                MBProgressHUD.hide(for: self._view, animated: true)
                self.viewModel.commentsViewModels = value
                self._view.detailTable.reloadData()
            case .failure(let error):
                MBProgressHUD.hide(for: self._view, animated: true)
                self.showAlertMessage(message: error.localizedDescription)
            }
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
        cell.userImage.loadImageUsingCache(withUrl: comment.user.imageURL, placeholderImage: UIImage(named: "user_male")!)
        cell.userName.text = comment.user.username
        cell.userComment.text = comment.content
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

// MARK: - Alert
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
