//
//  WBBooksRepository.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveCocoa
import ReactiveSwift

import Networking
import Argo
import Curry
import Runes
import Result

var networkingConfiguration: NetworkingConfiguration {
    var config = NetworkingConfiguration()
    config.domainURL = "swift-training-backend.herokuapp.com"
    return config
}

class WBBooksRepository: AbstractRepository {

    let userId = 5 //userID 5 ... because...
    
    // MARK: - Books
    func getBooks() -> SignalProducer<[WBBook], RepositoryError> {
        let path = "books"
        
        return performRequest(method: .get, path: path, parameters: nil) { JSON in
            return decode(JSON).toResult()
        }
    }
    
    // MARK: - User Rents
    func getRents() -> SignalProducer<[WBRent], RepositoryError> {
        let path = "users/\(userId)/rents"
        
        return performRequest(method: .get, path: path, parameters: nil) { JSON in
            return decode(JSON).toResult()
        }
    }

    func rentBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        let path = "users/\(userId)/rents"
        let params: [String: Any] = ["userID": userId,
                                     "bookID": book.id,
                                     "from": WBDateHelper.today(),
                                     "to": WBDateHelper.tomorrow()]
        
        return performRequest(method: .post, path: path, parameters: params) { _ in
            Result(value: ())
        }
    }
    
    // MARK: - Book Comments
    func getBookComments(book: WBBook) -> SignalProducer<[WBComment], RepositoryError> {
        let path = "books/\(book.id)/comments"
        
        return performRequest(method: .get, path: path, parameters: nil) { JSON in
            return decode(JSON).toResult()
        }
    }
    
    func addBookComment(comment: WBComment) -> SignalProducer<Void, RepositoryError> {
        let path = "books/\(comment.book.id)/comments"
        let params: [String: Any] = ["userID": userId,
                                     "bookID": comment.book.id,
                                     "content": comment.content]
        
        return performRequest(method: .post, path: path, parameters: params) { _ in
            Result(value: ())
        }
    }
    
    // MARK: - User Wishes
    func getWishes() -> SignalProducer<[WBWish], RepositoryError> {
        let path = "users/\(userId)/wishes"
        
        return performRequest(method: .get, path: path, parameters: nil) { JSON in
            return decode(JSON).toResult()
        }
    }

    func wishBook(book: WBBook) -> SignalProducer<Void, RepositoryError> {
        let path = "users/\(userId)/wishes"
        let params: [String: Any] = ["userID": userId,
                                     "bookID": book.id]
        
        return performRequest(method: .post, path: path, parameters: params) { _ in
            Result(value: ())
        }
    }

    // MARK: - Suggestions
    
    // MARK: - Private
    class func commonHeaders() -> [String: String] {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}
