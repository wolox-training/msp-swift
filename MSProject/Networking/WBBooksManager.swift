//
//  WBBooksManager.swift
//  MSProject
//
//  Created by Matias Spinelli on 27/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

import CoreSpotlight
import MobileCoreServices

class WBBooksManager {

    static let sharedIntance = WBBooksManager()

    private init() { }

    let imageCache = NSCache<NSString, UIImage>()

    var bookViewModels: MutableProperty<[WBBookViewModel]> = MutableProperty([])

    var rentedBooks: MutableProperty<[WBBookViewModel]> {
        return MutableProperty(bookViewModels.value.filter { $0.rented == true})
    }

    var wishedBooks: MutableProperty<[WBBookViewModel]> {
        return MutableProperty(bookViewModels.value.filter { $0.wished == true})
    }
    
    var needsReload = MutableProperty(false)
    
    // MARK: - Public
    func sortBooks(by: SortMethod) {
        sortBooks(books: &WBBooksManager.sharedIntance.bookViewModels.value, by: by)
    }
    
    // MARK: - Private
    private func sortBooks(books: inout [WBBookViewModel], by sortMethod: SortMethod) {
        switch sortMethod {
        case .id:
            books = books.sorted(by: { $0.book.id < $1.book.id })
        case .title:
            books = books.sorted(by: { $0.book.title < $1.book.title })
        case .author:
            books = books.sorted(by: { $0.book.author < $1.book.author })
        case .genre:
            books = books.sorted(by: { $0.book.genre < $1.book.genre })
        case .year:
            books = books.sorted(by: { $0.book.year < $1.book.year })
        }
    }
    
    // MARK: - Spotlight
    func indexSearchableItems() {
        var searchableItems = [CSSearchableItem] ()
        
        for book in WBBooksManager.sharedIntance.bookViewModels.value {
            let searchItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchItemAttributeSet.title = book.bookTitle
            searchItemAttributeSet.contentDescription = book.bookAuthor
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: book.bookId, domainIdentifier: "bookViewModels", attributeSet: searchItemAttributeSet)
            searchableItems.append(searchableItem)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
}
