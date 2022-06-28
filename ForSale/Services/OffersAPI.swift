//
//  OffersAPI.swift
//  ForSale
//
//  Created by costa.monzili on 26/06/2022.
//

import Foundation

protocol AnyURLSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

class OffersAPI: AnyOfferStore {
    var session: AnyURLSession = URLSession.shared

    enum Endpoints {
        static let categories = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
        static let offers = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    }

    func fetchCategories() async throws -> [OfferCategory] {
        try await fetchData(type: [OfferCategory].self, endpoint: Endpoints.categories)
    }

    func fetchOffers() async throws -> [Offer] {
        try await fetchData(type: [Offer].self, endpoint: Endpoints.offers)
    }

    private func fetchData<T: Decodable>(type: T.Type, endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else { throw NetworkError.url }
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode)
        else { throw NetworkError.server(response) }
        return try JSONDecoder().decode(type, from: data)
    }
}
