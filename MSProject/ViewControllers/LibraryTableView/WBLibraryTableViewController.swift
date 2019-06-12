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

    private let libraryTableView: WBLibraryTableView = WBLibraryTableView.loadFromNib()!

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
    
    var cellSelected: WBBookTableViewCell!
    var rectOfCellSelected: CGRect!
    
    override func loadView() {
        view = libraryTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLibraryTableViewModel()
        
        configureTableView()
        
        navigationItem.title = "LIBRARY".localized() + " Table"
        
        let sort = UIBarButtonItem(image: UIImage(named: "sort"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let search = UIBarButtonItem(image: UIImage(named: "ic_search"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [sort, search]

        navigationController?.delegate = self
        
        // molesta tener que agregar esto en todos los vc... grrr...
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = UIColor.woloxBackgroundColor()
        libraryTableView.libraryTableView.refreshControl = refreshControl
        
    }

    // MARK: - Private
    private func initLibraryTableViewModel() {
        libraryViewModel.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.libraryTableView.libraryTableView.reloadData()
            }
        }
        
        libraryViewModel.loadBooks()
    }
    
    private func configureTableView() {
        libraryTableView.libraryTableView.delegate = self
        libraryTableView.libraryTableView.dataSource = self
        
        libraryTableView.configureLibraryTableView()
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self.libraryTableView.libraryTableView.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension WBLibraryTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return libraryViewModel.heightOfCells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraryViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WBBookTableViewCell", for: indexPath) as? WBBookTableViewCell else {
            fatalError("Cell not exists")
        }
        
        let cellViewModel = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookCellViewModel = cellViewModel
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WBLibraryTableViewController: UITableViewDelegate {
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
                                   width: cellSelected.bookImage.frame.size.width,
                                   height: cellSelected.bookImage.frame.size.height)
        
        switch operation {
        case .push:
            return Transition(isPresenting: true, originFrame: arrengedFrame, transitionImage: cellSelected.bookImage.image ?? UIImage(named: "book_noun_001_01679")!)
        default:
            return Transition(isPresenting: false, originFrame: arrengedFrame, transitionImage: cellSelected.bookImage.image ?? UIImage(named: "book_noun_001_01679")!)
        }
    }
}
