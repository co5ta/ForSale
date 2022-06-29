//
//  ListOffersInteractorMock.swift
//  ForSaleTests
//
//  Created by costa.monzili on 29/06/2022.
//

import Foundation
@testable import ForSale

class ListOffersInteractorMock: AnyListOffersInteractor {
    var fetchOffersCalled = false

    func fetchOffers() async {
        fetchOffersCalled = true
    }
}
