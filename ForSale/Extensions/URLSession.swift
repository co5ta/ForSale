//
//  URLSession.swift
//  ForSale
//
//  Created by costa.monzili on 27/06/2022.
//

import Foundation

extension URLSession: AnyURLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?
        let onCancel = { task?.cancel() }

        return try await withTaskCancellationHandler(handler: {
            onCancel()
        }, operation: {
            try await withCheckedThrowingContinuation { continuation in
                task = self.dataTask(with: url) { data, response, error in
                    guard let data = data, let response = response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }
                    continuation.resume(returning: (data, response))
                }
                task?.resume()
            }
        })
    }
}
