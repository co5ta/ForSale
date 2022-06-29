//
//  ListOffersModels.swift
//  ForSale
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation

enum ListOffers {
    enum FetchOffers {
        struct Response {
            var categories: [OfferCategory]
            var offers: [Offer]
        }
        struct ViewModel {
            struct Offer: Hashable {
                let id: Int
                let title: String
                let categoryName: String?
            }
            var offers: [ViewModel.Offer]
        }
    }
}
