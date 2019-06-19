//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBLibraryTableViewController: UIViewController {

    private let _view: WBLibraryTableView = WBLibraryTableView.loadFromNib()!

    lazy var viewModel: WBLibraryViewModel = {
        return WBLibraryViewModel(booksRepository: WBNetworkManager(configuration: networkingConfiguration, defaultHeaders: nil))
    }()
        
    var cellSelected: WBBookTableViewCell!
    var rectOfCellSelected: CGRect!
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        navigationItem.title = "LIBRARY_NAV_BAR".localized()
        
        let sort = UIBarButtonItem(image: UIImage(named: "sort"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let search = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [sort, search]

        navigationController?.delegate = self
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookTable.refreshControl = refreshControl
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadBooks()
    }
    
    // MARK: - Private
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        _view.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        viewModel.repository.getBooks().startWithResult { [unowned self] result in
            switch result {
            case .success(let value):
                self._view.bookTable.refreshControl?.endRefreshing()
                TTLoadingHUDView.sharedView.hideViewWithSuccess()
                self.loadTableWithBooks(books: value)
            case .failure(let error):
                self._view.bookTable.refreshControl?.endRefreshing()
                TTLoadingHUDView.sharedView.hideViewWithFailure(error)
                self.showAlertError(error: error)
            }
        }
    }
    
    private func loadTableWithBooks(books: [WBBook]) {
        viewModel.libraryItems = books
        _view.bookTable.reloadData()
    }
    
    private func showAlertError(error: Error) {
        let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let book = viewModel.getCellViewModel(at: indexPath)
        cell.bookImage.loadImageUsingCache(withUrl: book.bookImageURL, placeholderImage: UIImage(named: "book_noun_001_01679")!)
        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        return cell
    }
    
}

extension WBLibraryTableViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set the selected cell and calculate the frame rect just for animation
        cellSelected = tableView.cellForRow(at: indexPath) as? WBBookTableViewCell
        let rectOfCell = tableView.rectForRow(at: indexPath)
        rectOfCellSelected = tableView.convert(rectOfCell, to: tableView.superview)

        let book = viewModel.selectBook(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController()
        detailBookViewController.bookView = book
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
    
}

extension WBLibraryTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let arrengedFrame = CGRect(x: rectOfCellSelected.origin.x + cellSelected.contentView.frame.origin.x + cellSelected.bookImage.frame.origin.x,
                                   y: rectOfCellSelected.origin.y + cellSelected.bookImage.frame.origin.y + cellSelected.contentView.frame.origin.y,
                                   width: cellSelected.bookImage.frame.width,
                                   height: cellSelected.bookImage.frame.height)
        
        switch operation {
        case .push:
            return Transition(isPresenting: true, originFrame: arrengedFrame, transitionImage: cellSelected.bookImage.image ?? UIImage(named: "book_noun_001_01679")!)
        default:
            return Transition(isPresenting: false, originFrame: arrengedFrame, transitionImage: cellSelected.bookImage.image ?? UIImage(named: "book_noun_001_01679")!)
        }
    }
}
