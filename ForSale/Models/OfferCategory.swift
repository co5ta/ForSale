//
//  OfferCategory.swift
//  ForSale
//
//  Created by costa.monzili on 26/06/2022.
//

import Foundation

struct OfferCategory: Codable {
    let id: Int
    let name: String
}

extension OfferCategory: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
