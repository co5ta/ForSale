//
//  ShowOfferModels.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import Foundation

enum ShowOffer {
    enum GetOffer {
        struct Response {
            let category: OfferCategory
            let offer: Offer
        }
        struct ViewModel {
            struct Offer {
                let id: Int
                let title: String
                let categoryId: Int
                let categoryName: String?
                let price: String?
                let date: String?
                let imagePath: String?
                let isUrgent: Bool
            }
            var offer: ViewModel.Offer
        }
    }
}
