//
//  WBDetailBookViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import MBProgressHUD

class WBDetailBookViewController: UIViewController {

    private let _view: WBDetailBookView = WBDetailBookView.loadFromNib()!
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFromNib()!

    lazy var bookDetailViewModel: WBBookDetailViewModel = {
        return WBBookDetailViewModel()
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
        _detailHeaderView.delegate = self
        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {
    
        bookDetailViewModel.showErrorAlertClosure = { [weak self] (error) in
            MBProgressHUD.hide(for: self?._view, animated: true)
            DispatchQueue.main.async {
                self?.showAlertMessage(message: error.localizedDescription)
            }
        }

        bookDetailViewModel.showAlertClosure = { [weak self] (message) in
            MBProgressHUD.hide(for: self?._view, animated: true)
            DispatchQueue.main.async {
                self?.showAlertMessage(message: message)
            }
        }
        
        bookDetailViewModel.reloadViewClosure = { [weak self] () in
            MBProgressHUD.hide(for: self?._view, animated: true)
            DispatchQueue.main.async {
                self?._view.detailTable.reloadData()
            }
        }
        
        MBProgressHUD.showAdded(to: _view, animated: true)
        bookDetailViewModel.loadComments(for: bookViewModel)
    }
    
    private func configureTableView() {
        _view.detailTable.delegate = self
        _view.detailTable.dataSource = self
        
        _view.configureDetailTableView()
    }
}

// MARK: - UITableViewDataSource
extension WBDetailBookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDetailViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBCommentsBookTableViewCell", for: indexPath) as? WBCommentsBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let comment = bookDetailViewModel.getCellViewModel(at: indexPath)
        cell.commentViewModel = comment

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

// MARK: - DetailBookDelegate
extension WBDetailBookViewController: DetailBookDelegate {
    func addToWishlist() {
        
    }
    
    func rentBook() {
        guard bookViewModel.bookStatus == .available else {
            showAlertMessage(message: "RENT_NOT_AVAILABLE".localized(withArguments: bookViewModel.bookStatus.bookStatusText()))
            return
        }
        MBProgressHUD.showAdded(to: _view, animated: true)
        bookDetailViewModel.rentBook(book: bookViewModel)
    }
}
