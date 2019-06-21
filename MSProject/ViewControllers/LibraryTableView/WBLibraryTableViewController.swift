//
//  WBLibraryTableViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore
import MBProgressHUD

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
        
        title = "LIBRARY_NAV_BAR".localized()
        
        let sort = UIBarButtonItem(image: UIImage.sortImage, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let search = UIBarButtonItem(image: UIImage.searchImage, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [sort, search]
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookTable.refreshControl = refreshControl
        
    }

    // MARK: - Private
    private func initLibraryTableViewModel() {
       
        libraryViewModel.showAlertClosure = { [weak self] (error) in
            MBProgressHUD.hide(for: self?._view, animated: true)
            DispatchQueue.main.async {
                self?.showAlertMessage(message: error.localizedDescription)
            }
        }
        
        libraryViewModel.reloadViewClosure = { [weak self] () in
            MBProgressHUD.hide(for: self?._view, animated: true)
            DispatchQueue.main.async {
                self?._view.bookTable.reloadData()
            }
        }
        
        MBProgressHUD.showAdded(to: _view, animated: true)
        libraryViewModel.loadBooks()
    }
    
    private func configureTableView() {
        _view.bookTable.delegate = self
        _view.bookTable.dataSource = self
        
        _view.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        MBProgressHUD.showAdded(to: _view, animated: true)
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
        cell.bookImage.loadImageUsingCache(withUrl: book.bookImageURL, placeholderImage: UIImage.placeholderBookImage)
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

        let book = libraryViewModel.selectBook(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController(with: book)
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
    
}
