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
    var libraryItems: [WBBook] = []
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        loadBooks()
        
        title = "LIBRARY".localized() + "Collection"
    }
    
    // MARK: - Private
    private func configureCollectionView() {
        _view.bookCollection.delegate = self
        _view.bookCollection.dataSource = self
        
        _view.bookCollection.backgroundColor = .woloxBackgroundLightColor()
        
        let nib = UINib.init(nibName: "WBBookCollectionViewCell", bundle: nil)
        _view.bookCollection.register(nib, forCellWithReuseIdentifier: "WBBookCollectionViewCell")
    }
    
    // MARK: - Services
    private func loadBooks() {
        libraryItems = WBBookDAO.sharedInstance.getAllBooks()
        _view.bookCollection.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource
extension WBLibraryCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WBBookCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WBBookCollectionViewCell", for: indexPath) as! WBBookCollectionViewCell // swiftlint:disable:this force_cast
        
        let book: WBBook = libraryItems[indexPath.row]
        
        cell.bookImage.image = UIImage(named: book.bookImageURL ?? "placeholder_image")
        cell.bookTitle.text = book.bookTitle
        cell.bookAuthor.text = book.bookAuthor
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension WBLibraryCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book: WBBook = libraryItems[indexPath.row]
        print("\(book.bookTitle ?? "") \(book.bookAuthor ?? "")")
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
