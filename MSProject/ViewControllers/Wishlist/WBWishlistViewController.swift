//
//  WBWishlistViewController.swift
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

class WBWishlistViewController: UIViewController {

    private let _view: WBWishlistView = WBWishlistView.loadFromNib()!

    lazy var viewModel: WBWishlistViewModel = {
        return WBWishlistViewModel(booksRepository: WBBooksRepository(configuration: networkingConfiguration, defaultHeaders: WBBooksRepository.commonHeaders()))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        loadWishes()

        title = "WISHLIST_NAV_BAR".localized()
    }
    
    override func loadView() {
        view = _view
    }

    // MARK: - Private
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        let nib = UINib.init(nibName: "WBBookTableViewCell", bundle: nil)
        _view.bookTable.register(nib, forCellReuseIdentifier: "WBBookTableViewCell")
        
        _view.configureLibraryTableView()
    }
    
    private func loadWishes() {
        self._view.bookTable.reloadData()
    }
}

extension WBWishlistViewController: UITableViewDataSource {
    
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

extension WBWishlistViewController: UITableViewDelegate {
    
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
