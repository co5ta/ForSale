//
//  ListOffersWorker.swift
//  ForSale
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation

class ListOffersWorker {

    var store: AnyOfferStore

    init(store: AnyOfferStore) {
        self.store = store
    }

    func fetchCategories() async throws -> [OfferCategory] {
        let categories = try await store.fetchCategories()
        return categories
    }

    func fetchOffers() async throws -> [Offer] {
        let offers = try await store.fetchOffers()
        return offers
    }
}


protocol AnyOfferStore {
    func fetchCategories() async throws -> [OfferCategory]
    func fetchOffers() async throws -> [Offer]
}
