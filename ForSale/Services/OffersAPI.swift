//
//  OffersAPI.swift
//  ForSale
//
//  Created by costa.monzili on 26/06/2022.
//

import Foundation
import UIKit.UIImage

protocol AnyURLSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

protocol AnyOfferStore {
    func fetchCategories() async throws -> [OfferCategory]
    func fetchOffers() async throws -> [Offer]
    func fetchImage(path: String) async -> UIImage?
}

class OffersAPI: AnyOfferStore {
    var session: AnyURLSession = URLSession.shared
    let decoder = JSONDecoder()

    enum Endpoints {
        static let categories = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
        static let offers = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    }

    func fetchCategories() async throws -> [OfferCategory] {
        try await fetchData(type: [OfferCategory].self, path: Endpoints.categories)
    }

    func fetchOffers() async throws -> [Offer] {
        try await fetchData(type: [Offer].self, path: Endpoints.offers)
    }

    func fetchImage(path: String) async -> UIImage? {
        guard let data = try? await fetchData(path: path) else { return nil }
        return UIImage(data: data)
    }

    /// Fetchs and returns decoded data
    private func fetchData<T: Decodable>(type: T.Type, path: String) async throws -> T {
        let data = try await fetchData(path: path)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }

    /// Fetchs and return data
    private func fetchData(path: String) async throws -> Data {
        guard let url = URL(string: path) else { throw NetworkError.url }
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode)
        else { throw NetworkError.server(response) }
        return data
    }
}
