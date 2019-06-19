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

class WBDetailBookViewController: UIViewController {

    private let _view: WBDetailBookView = WBDetailBookView.loadFromNib()!
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFromNib()!

    lazy var viewModel: WBBookDetailViewModel = {
        return WBBookDetailViewModel(booksRepository: WBNetworkManager(configuration: networkingConfiguration, defaultHeaders: nil))
    }()
    
    var bookView: WBBookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "BOOK_DETAIL".localized()

        configureTableView()
        
        initBookDetailTableViewModel()
    }
    
    override func loadView() {
        _detailHeaderView.setBook(bookViewModel: bookView)
        _detailHeaderView.configureUI()
        
        _detailHeaderView.rentButton.setTitle("RENT_BOOK_BUTTON".localized(), for: .normal)
        _detailHeaderView.wishlistButton.setTitle("WISHLIST_ADD_BUTTON".localized(), for: .normal)

        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {

        viewModel.rentBookAction.values.observeValues { [unowned self] _ in
            TTLoadingHUDView.sharedView.hideViewWithSuccess()
            self.showAlertMessage(message: "Se reservo el libro correctamente")
            self.viewModel.bookAvailable.value = false
        }
        
        viewModel.rentBookAction.errors.observeValues { [unowned self] error in
            TTLoadingHUDView.sharedView.hideViewWithFailure(error)
            self.showAlertMessage(message: error.localizedDescription)
        }
        
        viewModel.rentBookAction.isExecuting.signal.observeValues { [unowned self] isExecuting in
            if isExecuting {
                TTLoadingHUDView.sharedView.showLoading(inView: self._view)
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

        viewModel.bookAvailable.value = bookView.bookStatus.bookStatusAvailable()
        
        _detailHeaderView.rentButton.reactive.pressed = CocoaAction(viewModel.rentBookAction, input: bookView.book)
        
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
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        viewModel.repository.getBookComments(book: bookView.book).startWithResult { [unowned self] result in
            switch result {
            case .success(let value):
                TTLoadingHUDView.sharedView.hideViewWithSuccess()
                self.viewModel.commentsViewModels = value
                self._view.detailTable.reloadData()
            case .failure(let error):
                TTLoadingHUDView.sharedView.hideViewWithFailure(error)
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

// MARK: - Actions
extension WBDetailBookViewController {
    func addToWishlist() {
        
    }

//    func rentBook() {
//        guard bookView.bookStatus == .available else {
//            self.showAlertMessage(message: "No puedes rentar un libro \(bookView.bookStatus.bookStatusText()). lol")
//            return
//        }
//        TTLoadingHUDView.sharedView.showLoading(inView: _view)
//
//        viewModel.repository.rentBook(book: bookView.book).startWithResult { [unowned self] result in
//            switch result {
//            case .success():
//                TTLoadingHUDView.sharedView.hideViewWithSuccess()
//                self.showAlertMessage(message: "Se reservo el libro correctamente")
//                // CAMBIAR BOTON!!!
//
//            case .failure(let error):
//                TTLoadingHUDView.sharedView.hideViewWithFailure(error)
//                self.showAlertMessage(message: error.localizedDescription)
//            }
//        }
//    }
}

// MARK: - Alert
extension WBDetailBookViewController {
    private func showAlertMessage(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
