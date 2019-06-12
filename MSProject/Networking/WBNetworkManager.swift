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
    
    public func rentBook(book: WBBook, onSuccess: @escaping (WBRent) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "https://swift-training-backend.herokuapp.com/users/5/rents")!

        let params: [String: Any] = ["userID": 5,
                                     "bookID": book.id,
                                    "from": DateHelper.today(),
                                    "to": DateHelper.tomorrow()]
        
        request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                
//                {
//                    "from": "2018-06-12",
//                    "id": 113,
//                    "to": "2018-06-13",
//                    "bookID": 5,
//                    "userID": 2
//                }
                
                guard let JSONbooks = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                    onError(BookError.decodeError)
                    return
                }
                guard let rent = try? JSONDecoder().decode(WBRent.self, from: JSONbooks) else {
                    onError(BookError.decodeError)
                    return
                }
                
                onSuccess(rent)
            case .failure(let error):
                onError(error)
            }
        }
        
    }
    
}
