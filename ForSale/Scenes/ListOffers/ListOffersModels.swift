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
            struct Category {
                let id: Int
                let name: String
            }
            struct Offer: AnyOffer, Hashable {
                let id: Int
                let title: String
                let categoryId: Int
                let categoryName: String?
                let price: String?
                let date: String?
                let imagePath: String?
                let isUrgent: Bool
            }
            var categories: [ViewModel.Category]
            var offers: [ViewModel.Offer]
        }
    }
}
