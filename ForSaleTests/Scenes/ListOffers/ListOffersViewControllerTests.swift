//
//  ListOffersViewControllerTests.swift
//  ForSaleTests
//
//  Created by costa.monzili on 29/06/2022.
//

import XCTest
@testable import ForSale

class ListOffersViewControllerTests: XCTestCase {

    var sut: ListOffersViewController!
    var interactorMock: ListOffersInteractorMock!

    override func setUpWithError() throws {
        sut = ListOffersViewController()
        interactorMock = ListOffersInteractorMock()
        sut.interactor = interactorMock
    }

    override func tearDownWithError() throws {
        sut = nil
        interactorMock = nil
    }

    func test_fetchOffers_shouldTellInteractorToCallFetchOffers() async {
        await sut.fetchOffers()

        XCTAssertTrue(interactorMock.fetchOffersCalled)
    }

    func test_shouldContainsCollectionView() {
        XCTAssertTrue(sut.collectionView2.isDescendant(of: sut.view))
    }
}
