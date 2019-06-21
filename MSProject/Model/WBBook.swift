//
//  WBBook.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import WolmoCore

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

struct WBBook: Codable {
    
    let id: Int
    let title: String
    let author: String
    let status: String
    let genre: String
    let year: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case status
        case genre
        case year
        case imageURL = "image"
    }
}

struct WBBookViewModel {
    
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
}
