//
//  ListOffersPresenterMock.swift
//  ForSaleTests
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation
@testable import ForSale

class ListOffersPresenterMock: AnyListOffersPresenter {
    var presentResponseCalled = false
    var presentErrorMessageCalled = false

    func present(response: ListOffers.FetchOffers.Response) {
        presentResponseCalled = true
    }

    func present(errorMessage: String) {
        presentErrorMessageCalled = true
    }
}
