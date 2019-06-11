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
    
}
