//
//  ListOffersInteractor.swift
//  ForSale
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation

protocol AnyListOffersInteractor {
    func fetchOffers() async
}

protocol AnyListOffersDataStore {
    var categories: [OfferCategory] { get }
    var offers: [Offer] { get }
}

class ListOffersInteractor: AnyListOffersInteractor, AnyListOffersDataStore {
    var worker = ListOffersWorker(store: OffersAPI())
    var presenter: AnyListOffersPresenter?
    var categories: [OfferCategory] = []
    var offers: [Offer] = []

    func fetchOffers() async {
        do {
            categories = try await worker.fetchCategories()
            offers = try await worker.fetchOffers().sortedByDate()
            let response = ListOffers.FetchOffers.Response(categories: categories, offers: offers)
            await presenter?.present(response: response)
        } catch {
            print(error.localizedDescription)
            await presenter?.present(errorMessage: "An error occured")
        }
    }
}
