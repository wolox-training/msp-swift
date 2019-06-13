//
//  WBDetailBookViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBDetailBookViewController: UIViewController {

    private let _view: WBDetailBookView = WBDetailBookView.loadFromNib()!
    private let _detailHeaderView: WBDetailBookHeaderView = WBDetailBookHeaderView.loadFromNib()!

    lazy var bookDetailViewModel: WBBookDetailViewModel = {
        return WBBookDetailViewModel()
    }()
    
    var bookView: WBBookViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = bookView.bookTitle
        
        configureTableView()
        
        initBookDetailTableViewModel()
    }
    
    override func loadView() {
        _detailHeaderView.bookViewModel = bookView
        _detailHeaderView.delegate = self
        _view.detailHeaderView.addSubview(_detailHeaderView)
        view = _view
    }

    // MARK: - Private
    private func initBookDetailTableViewModel() {
    
        bookDetailViewModel.showAlertClosure = { [weak self] (error) in
            TTLoadingHUDView.sharedView.hideViewWithFailure(error)
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okButton)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        bookDetailViewModel.reloadViewClosure = { [weak self] () in
            TTLoadingHUDView.sharedView.hideViewWithSuccess()
            DispatchQueue.main.async {
                self?._view.detailTable.reloadData()
            }
        }
        
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        bookDetailViewModel.loadComments(for: bookView)
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
        return UITableViewAutomaticDimension
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
        guard bookView.bookStatus == .available else {
            let alertController = UIAlertController(title: "", message: "No puedes rentar un libro \(bookView.bookStatus.bookStatusText()). lol", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okButton)
            present(alertController, animated: true, completion: nil)
            return
        }
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        WBBookDAO.sharedInstance.rentBook(delegate: self, book: bookView.book)
    }
}

// MARK: - WBRentProtocol
extension WBDetailBookViewController: WBRentProtocol {
    func rentSucess(rent: WBRent) {
        TTLoadingHUDView.sharedView.hideViewWithSuccess()
        let alertController = UIAlertController(title: "", message: "Se reservo el libro correctamente", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func rentFailue(error: Error) {
        TTLoadingHUDView.sharedView.hideViewWithFailure(error)
    }
}
