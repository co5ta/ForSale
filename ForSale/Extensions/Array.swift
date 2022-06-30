//
//  Array.swift
//  ForSale
//
//  Created by costa.monzili on 30/06/2022.
//

import Foundation

extension Array where Element == Offer {
    func sortedByDate() -> [Element] {
        sorted { lhs, rhs in
            if (lhs.isUrgent == rhs.isUrgent) {
                return lhs.creationDate > rhs.creationDate
            }
            return lhs.isUrgent && !rhs.isUrgent
        }
    }
}
