//
//  OffersAPIMock.swift
//  ForSaleTests
//
//  Created by costa.monzili on 27/06/2022.
//

import Foundation
@testable import ForSale

class OffersAPIMock: OffersAPI {
    var fetchCategoriesCalled = false
    var fetchCategoriesError: Error?
    var fetchCategoriesData: [OfferCategory]?

    var fetchOffersCalled = false
    var fetchOffersError: Error?
    var fetchOffersData: [Offer]?

    override func fetchCategories() async throws -> [OfferCategory] {
        fetchCategoriesCalled = true
        if let error = fetchCategoriesError {
            throw error
        }
        guard let categories = fetchCategoriesData else { return [] }
        return categories
    }

    override func fetchOffers() async throws -> [Offer] {
        fetchOffersCalled = true
        if let error = fetchOffersError {
            throw error
        }
        guard let offers = fetchOffersData else { return [] }
        return offers
    }
}
