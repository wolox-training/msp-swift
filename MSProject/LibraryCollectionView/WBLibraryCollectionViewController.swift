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

    lazy var libraryViewModel: WBLibraryViewModel = {
        return WBLibraryViewModel()
    }()
    private let _view: WBLibraryCollectionView = WBLibraryCollectionView.loadFromNib()!
    var libraryItems: [WBBook] = []
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLibraryCollectionViewModel()

        configureCollectionView()
        
        navigationItem.title = "LIBRARY".localized() + " Collection"
        
        // Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadBooks), for: .valueChanged)
        refreshControl.tintColor = .woloxBackgroundColor()
        _view.bookCollection.refreshControl = refreshControl
    }
    
    // MARK: - Private
    private func initLibraryCollectionViewModel() {
        libraryViewModel.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?._view.bookCollection.reloadData()
            }
        }
        
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
        libraryViewModel.loadBooks()
        DispatchQueue.main.async {
            self._view.bookCollection.reloadData()
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
        
        let book = libraryViewModel.getCellViewModel(at: indexPath)
        cell.bookImage.image = UIImage(named: "book_noun_001_01679")
        if let cachedImage = WBBookDAO.sharedInstance.imageCache.object(forKey: NSString(string: (book.image))) {
            DispatchQueue.main.async {
                cell.bookImage.image = cachedImage
            }
        } else {
            let urlString = book.image
            if urlString.hasPrefix("https://") || urlString.hasPrefix("http://") {
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        let image: UIImage = UIImage(data: data)!
                        DispatchQueue.main.async {
                            WBBookDAO.sharedInstance.imageCache.setObject(image, forKey: NSString(string: urlString))
                            cell.bookImage.image = image
                        }
                    }
                }
            }
        }
        cell.bookTitle.text = book.title
        cell.bookAuthor.text = book.author
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension WBLibraryCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        libraryViewModel.selectBook(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
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
