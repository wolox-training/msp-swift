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

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
        
    var cellSelected: WBBookTableViewCell!
    var rectOfCellSelected: CGRect!
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLibraryTableViewModel()
        
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

    // MARK: - Private
    private func initLibraryTableViewModel() {
       
        libraryViewModel.showAlertClosure = { [weak self] (error) in
            TTLoadingHUDView.sharedView.hideViewWithFailure(error)
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okButton)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        libraryViewModel.reloadViewClosure = { [weak self] () in
            TTLoadingHUDView.sharedView.hideViewWithSuccess()
            DispatchQueue.main.async {
                self?._view.bookTable.reloadData()
            }
        }
        
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        libraryViewModel.loadBooks()
    }
    
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        _view.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self._view.bookTable.refreshControl?.endRefreshing()
        }
    }
    
}

extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let book = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookImage.loadImageUsingCache(withUrl: book.bookImageURL, placeholderImage: UIImage(named: "book_noun_001_01679")!)
        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        return cell
    }
    
}

extension WBLibraryTableViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return libraryViewModel.heightOfCells
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set the selected cell and calculate the frame rect just for animation
        cellSelected = tableView.cellForRow(at: indexPath) as? WBBookTableViewCell
        let rectOfCell = tableView.rectForRow(at: indexPath)
        rectOfCellSelected = tableView.convert(rectOfCell, to: tableView.superview)

        let book = libraryViewModel.selectBook(at: indexPath)
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
