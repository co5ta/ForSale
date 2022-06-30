//
//  Offer.swift
//  ForSale
//
//  Created by costa.monzili on 26/06/2022.
//

import Foundation

struct Offer: Codable {
    let id: Int
    let title: String
    let categoryId: Int
    let description: String
    let price: Float
    let imagesUrl: ImagesUrl?
    let creationDate: Date
    let isUrgent: Bool
    let siret: String?

    struct ImagesUrl: Codable {
        let small: String?
        let thumb: String?
    }
}

extension Offer: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
