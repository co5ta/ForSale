//
//  NetworkError.swift
//  ForSale
//
//  Created by costa.monzili on 27/06/2022.
//

import Foundation

enum NetworkError: Error {
    case url
    case client(Error)
    case server(URLResponse?)
    case noData
    case decoding(Error?)
    case noResult
}
