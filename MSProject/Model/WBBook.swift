//
//  WBBook.swift
//  MSProject
//
//  Created by Matias Spinelli on 07/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

enum BookStatus: CaseIterable {
    case rented
    case inYourHands
    case available
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "rented":
            self = .rented
        case "inYourHands":
            self = .inYourHands
        case "available":
            self = .available
        default:
            self = .unknown
        }
    }
    
    func bookStatusText() -> String {
        switch self {
        case .available:
            return "Available"
        default:
            return "Not Available"
        }
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
        return String(self.book.id)
    }
    
    var bookTitle: String {
        return self.book.title
    }
    
    var bookAuthor: String {
        return self.book.author
    }
    
    var bookStatus: BookStatus {
        return BookStatus(rawValue: book.status)
    }
    
    var bookGenre: String {
        return self.book.genre
    }
    
    var bookYear: String {
        return self.book.year
    }
    
    var bookImageURL: String {
        return self.book.imageURL
    }
}
