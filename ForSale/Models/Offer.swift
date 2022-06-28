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
    let idCategory: Int
}

extension Offer: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
