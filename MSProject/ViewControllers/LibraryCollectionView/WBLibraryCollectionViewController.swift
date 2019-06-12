//
//  WBLibraryCollectionViewController.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBLibraryCollectionViewController: UIViewController {

    private let libraryCollectionView: WBLibraryCollectionView = WBLibraryCollectionView.loadFromNib()!

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
    
    override func loadView() {
        view = libraryCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLibraryCollectionViewModel()

        configureCollectionView()
        
        navigationItem.title = "LIBRARY".localized() + " Collection"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = UIColor.woloxBackgroundColor()
        libraryCollectionView.libraryCollectionView.refreshControl = refreshControl
    }
    
    // MARK: - Private
    private func initLibraryCollectionViewModel() {
        libraryViewModel.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.libraryCollectionView.libraryCollectionView.reloadData()
            }
        }
        
        libraryViewModel.loadBooks()
    }
    
    private func configureCollectionView() {
        libraryCollectionView.libraryCollectionView.delegate = self
        libraryCollectionView.libraryCollectionView.dataSource = self
        
        libraryCollectionView.libraryCollectionView.backgroundColor = UIColor.woloxBackgroundLightColor()
        
        let nib = UINib.init(nibName: "WBBookCollectionViewCell", bundle: nil)
        libraryCollectionView.libraryCollectionView.register(nib, forCellWithReuseIdentifier: "WBBookCollectionViewCell")
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self.libraryCollectionView.libraryCollectionView.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension WBLibraryCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WBBookCollectionViewCell", for: indexPath) as? WBBookCollectionViewCell else {
            fatalError("Cell not exists")
        }
        
        let cellViewModel = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookCellViewModel = cellViewModel
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension WBLibraryCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = libraryViewModel.selectBook(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController()
        detailBookViewController.bookView = book
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WBLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthFloat = CGFloat(collectionView.frame.width)-40 //40 es el padding, 20 izquierda y 20 derecha
        return CGSize(width: widthFloat, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
