//
//  WBSuggestionsTableViewCell.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

class WBSuggestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var suggestionBooks: [WBBookViewModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear

        suggestionTitle.text = "SUGGESTIONS".localized()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let collectionViewFlowControl = UICollectionViewFlowLayout()
        collectionViewFlowControl.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionViewFlowControl.itemSize = CGSize(width: 55, height: 70)
        collectionView.collectionViewLayout = collectionViewFlowControl
        
        let nib = UINib.init(nibName: "WBSuggestionBookImageCollectionViewCell", bundle: nil)
       collectionView.register(nib, forCellWithReuseIdentifier: "WBSuggestionBookImageCollectionViewCell")
    }
    
    func setup(with suggestions: [WBBookViewModel]) {
        suggestionBooks = suggestions
        collectionView.reloadData()
    }
}

extension WBSuggestionsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WBSuggestionBookImageCollectionViewCell", for: indexPath) as? WBSuggestionBookImageCollectionViewCell else {
            fatalError("Cell not exists")
        }
        
        let book = suggestionBooks[indexPath.row]
        cell.setup(with: book)
        return cell

    }
}

extension WBSuggestionsTableViewCell: UICollectionViewDelegate {
    
}
