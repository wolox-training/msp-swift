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
    private let libraryCollectionView: WBLibraryCollectionView = WBLibraryCollectionView.loadFromNib()!

    override func loadView() {
        view = libraryTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        libraryTableView.configureTableView()
        libraryCollectionView.configureCollectionView()
        
        loadBooks()
        
        title = "LIBRARY".localized()
        
        let grid = UIBarButtonItem(image: UIImage(named: "grid"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(gridMode))
        navigationItem.rightBarButtonItem = grid
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func gridMode() {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.view.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                if self.view.isKind(of: WBLibraryTableView.self) {
                    self.view = self.libraryCollectionView
                    self.libraryCollectionView.libraryCollectionView.reloadData()
                } else {
                    self.view = self.libraryTableView
                    self.libraryTableView.libraryTableView.reloadData()
                }
                self.view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    // MARK: - Services
    func loadBooks() {
        libraryTableView.libraryItems = WBBookDAO.sharedInstance.getAllBooks()
        libraryTableView.libraryTableView.reloadData()
        libraryCollectionView.libraryItems = WBBookDAO.sharedInstance.getAllBooks()
        libraryCollectionView.libraryCollectionView.reloadData()
    }
    
}
