//
//  URLSessionMock.swift
//  ForSaleTests
//
//  Created by costa.monzili on 27/06/2022.
//

import Foundation
@testable import ForSale

class URLSessionMock: AnyURLSession {
    var urlSessionResult: (Data, URLResponse)?
    var urlSessionError: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = urlSessionError {
            throw error
        }
        guard let result = urlSessionResult
        else { fatalError() }
        return result
    }
}
