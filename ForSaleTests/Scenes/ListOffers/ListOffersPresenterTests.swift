//
//  ListOffersPresenterTests.swift
//  ForSaleTests
//
//  Created by costa.monzili on 28/06/2022.
//

import XCTest
@testable import ForSale

class ListOffersPresenterTests: XCTestCase {

    var sut: ListOffersPresenter!
    var viewControllerMock: ListOffersViewControllerMock!
    var dummyResponse: ListOffers.FetchOffers.Response!
    let dummyOffer1 = Offer(id: 1, title: "", idCategory: 11)
    let dummyOffer2 = Offer(id: 2, title: "", idCategory: 12)
    let dummyCategory1 = OfferCategory(id: 11, title: "Category 11")
    let dummyCategory2 = OfferCategory(id: 12, title: "Category 12")

    override func setUpWithError() throws {
        sut = ListOffersPresenter()
        viewControllerMock = ListOffersViewControllerMock()
        sut.viewController = viewControllerMock
        dummyResponse = setUpDummyResponse()
    }

    func setUpDummyResponse() -> ListOffers.FetchOffers.Response {
        let categories = [
            dummyCategory1,
            dummyCategory2
        ]
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]
        return ListOffers.FetchOffers.Response(categories: categories, offers: offers)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_presentOffers_shouldTellViewControllerToCallDisplayOffers() {
        sut.present(response: dummyResponse)
        XCTAssertTrue(viewControllerMock.displayOffersCalled)
    }

    func test_presentErrorMessage_shouldTellViewControllerToCallDisplayErrorMessage() {
        sut.present(errorMessage: "")
        XCTAssertTrue(viewControllerMock.displayErrorMessageCalled)
    }

    func test_presentOffers_shouldFormatOffersForViewModel() throws {
        sut.present(response: dummyResponse)
        let viewModel = try XCTUnwrap(viewControllerMock.viewModel)
        let offer1 = viewModel.offers[0]
        let offer2 = viewModel.offers[1]

        XCTAssertEqual(offer1.title, dummyOffer1.title)
        XCTAssertEqual(offer1.categoryName, dummyCategory1.title)

        XCTAssertEqual(offer2.title, dummyOffer2.title)
        XCTAssertEqual(offer2.categoryName, dummyCategory2.title)
    }
}
