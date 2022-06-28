//
//  NetworkError.swift
//  ForSale
//
//  Created by costa.monzili on 27/06/2022.
//

import Foundation

enum NetworkError: Error {
    case url
    case server(URLResponse?)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.url, .url):
            return true
        case (.server, .server):
            return true
        default:
            return false
        }
    }
}
