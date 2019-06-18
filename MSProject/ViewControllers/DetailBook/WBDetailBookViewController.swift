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
        _detailHeaderView.bookViewModel = bookView
        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {
    
//        viewModel.showErrorAlertClosure = { [weak self] (error) in
//            TTLoadingHUDView.sharedView.hideViewWithFailure(error)
//            DispatchQueue.main.async {
//                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alertController.addAction(okButton)
//                self?.present(alertController, animated: true, completion: nil)
//            }
//        }

//        viewModel.showAlertClosure = { [weak self] (message) in
//            TTLoadingHUDView.sharedView.hideViewWithSuccess()
//            DispatchQueue.main.async {
//                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alertController.addAction(okButton)
//                self?.present(alertController, animated: true, completion: nil)
//            }
//        }
        
//        viewModel.reloadViewClosure = { [weak self] () in
//            TTLoadingHUDView.sharedView.hideViewWithSuccess()
//            DispatchQueue.main.async {
//                self?._view.detailTable.reloadData()
//            }
//        }
        
        _detailHeaderView.rentButton.reactive.controlEvents(.touchUpInside).observeValues { _ in
            self.rentBook()
        }
        
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
                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
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

    func rentBook() {
        guard bookView.bookStatus == .available else {
            let alertController = UIAlertController(title: "", message: "No puedes rentar un libro \(bookView.bookStatus.bookStatusText()). lol", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okButton)
            present(alertController, animated: true, completion: nil)
            return
        }
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
//        viewModel.rentBook(book: bookView)
    }
}
