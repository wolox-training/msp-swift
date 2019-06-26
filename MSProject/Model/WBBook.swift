//
//  WBBook.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

import Argo
import Curry
import Runes

enum BookStatus: String, CaseIterable {
    case rented
    case inYourHands
    case available
    case unknown
    
    func bookStatusText() -> String {
        switch self {
        case .available:
            return "AVAILABLE".localized()
        default:
            return "NOT_AVAILABLE".localized()
        }
    }
    
    func isBookAvailable() -> Bool {
        return self == .available
    }
    
}

struct WBBook {
    
    let id: Int
    let title: String
    let author: String
    let status: String
    let genre: String
    let year: String
    let imageURL: String
    
}

extension WBBook: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<WBBook> {
        return curry(WBBook.init)
            <^> json <| "id"
            <*> json <| "title"
            <*> json <| "author"
            <*> json <| "status"
            <*> json <| "genre"
            <*> json <| "year"
            <*> json <| "image"
    }
}

class WBBookViewModel: NSObject {

    let book: WBBook
    
    init(book: WBBook) {
        self.book = book
    }
    
    var bookId: String {
        return String(book.id)
    }
    
    var bookTitle: String {
        return book.title
    }
    
    var bookAuthor: String {
        return book.author
    }
    
    var bookStatus: BookStatus {
        if rented == true {
            return .rented
        }
        return BookStatus(rawValue: book.status) ?? .unknown
    }
    
    var bookGenre: String {
        return book.genre
    }
    
    var bookYear: String {
        return book.year
    }
    
    var bookImageURL: String {
        return book.imageURL
    }
    
    var wished: Bool = false
    var rented: Bool = false
}
