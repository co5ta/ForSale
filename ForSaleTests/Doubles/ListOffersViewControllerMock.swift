//
//  ListOffersViewControllerMock.swift
//  ForSaleTests
//
//  Created by costa.monzili on 28/06/2022.
//

import Foundation
@testable import ForSale

class ListOffersViewControllerMock: AnyListOffersViewController {
    var displayOffersCalled = false
    var displayErrorMessageCalled = false
    var viewModel: ListOffers.FetchOffers.ViewModel?

    func displayOffers(from viewModel: ListOffers.FetchOffers.ViewModel)  {
        displayOffersCalled = true
        self.viewModel = viewModel
    }

    func display(errorMessage: String) {
        displayErrorMessageCalled = true
    }
}


