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

    private let _view: WBLibraryCollectionView = WBLibraryCollectionView.loadFromNib()!

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
    
    var libraryItems: [WBBook] = []
    
    override func loadView() {
        view = _view
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
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookCollection.refreshControl = refreshControl
    }
    
    // MARK: - Private
    private func initLibraryCollectionViewModel() {
        
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
                self?._view.bookCollection.reloadData()
            }
        }
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        libraryViewModel.loadBooks()
    }
    
    private func configureCollectionView() {
        _view.bookCollection.delegate = self
        _view.bookCollection.dataSource = self
        
        _view.bookCollection.backgroundColor = .woloxBackgroundLightColor()
        
        let nib = UINib.init(nibName: "WBBookCollectionViewCell", bundle: nil)
        _view.bookCollection.register(nib, forCellWithReuseIdentifier: "WBBookCollectionViewCell")
    }
    
    // MARK: - Services
    @objc private func loadBooks() {
        TTLoadingHUDView.sharedView.showLoading(inView: _view)
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self._view.bookCollection.refreshControl?.endRefreshing()
        }
    }
    
}

extension WBLibraryCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WBBookCollectionViewCell", for: indexPath) as? WBBookCollectionViewCell else {
            fatalError("Cell not exists")
        }
        
        let bookViewModel = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookViewModel = bookViewModel
        
        return cell
    }
    
}

extension WBLibraryCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = libraryViewModel.selectBook(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailBookViewController = WBDetailBookViewController()
        detailBookViewController.bookView = book
        navigationController?.pushViewController(detailBookViewController, animated: true)
    }
    
}

extension WBLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthFloat = CGFloat(collectionView.frame.width)-40 //40 es el padding, 20 izquierda y 20 derecha
        return CGSize(width: widthFloat, height: 90.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
