//
//  WBNetworkManager.swift
//  MSProject
//
//  Created by Matias Spinelli on 11/06/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit
import Alamofire

enum BookError: Error {
    case decodeError
}

class WBNetworkManager: NSObject {

    public static let manager = WBNetworkManager()
    
    override init() {}

    let userId = 5 //userID 5 ... because...

    public func fetchBooks(onSuccess: @escaping ([WBBook]) -> Void, onError: @escaping (Error) -> Void) {

        let url = URL(string: "https://swift-training-backend.herokuapp.com/books")!

        request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONbooks = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let books = try? JSONDecoder().decode([WBBook].self, from: JSONbooks) else {
                    onError(BookError.decodeError)
                    return
                }
                onSuccess(books)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    // MARK: - Rentals
    public func getRentals(onSuccess: @escaping ([WBRent]) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/users/\(userId)/rents")!
        
        request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: commonHeaders()).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let rents = try? JSONDecoder().decode([WBRent].self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(rents)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    public func rentBook(book: WBBook, onSuccess: @escaping (WBRent) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/users/\(userId)/rents")!

        let params: [String: Any] = ["userID": userId,
                                     "bookID": book.id,
                                    "from": WBDateHelper.today(),
                                    "to": WBDateHelper.tomorrow()]
        
        request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: commonHeaders()).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let rent = try? JSONDecoder().decode(WBRent.self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(rent)
            case .failure(let error):
                onError(error)
            }
        }
    }

    // MARK: - Comments
    public func getBookComments(book: WBBook, onSuccess: @escaping ([WBComment]) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/books/\(book.id)/comments")!
  
        let headers: [String: String] = commonHeaders()

        request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let comments = try? JSONDecoder().decode([WBComment].self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(comments)
            case .failure(let error):
                onError(error)
            }
        }
    }

    public func addBookComment(comment: WBComment, onSuccess: @escaping (WBComment) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/books/\(comment.book.id)/comments")!
        
        let params: [String: Any] = ["userID": userId,
                                     "bookID": comment.book.id,
                                     "content": comment.content]

        request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: commonHeaders()).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let comment = try? JSONDecoder().decode(WBComment.self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(comment)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    // MARK: - Wish
    public func getWishes(onSuccess: @escaping ([WBWish]) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/users/\(userId)/wishes")!
        
        request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: commonHeaders()).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let wishes = try? JSONDecoder().decode([WBWish].self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(wishes)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    public func addWishBook(book: WBBook, onSuccess: @escaping (WBWish) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/users/\(userId)/wishes")!
        
        let params: [String: Any] = ["userID": userId,
                                     "bookID": book.id]
        
        request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: commonHeaders()).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSONrent = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let wish = try? JSONDecoder().decode(WBWish.self, from: JSONrent) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(wish)
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    // MARK: - Private
    private func commonHeaders() -> [String: String] {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
}
