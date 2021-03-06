//
//  ListOffersInteractorTests.swift
//  ListOffersInteractorTests
//
//  Created by costa.monzili on 25/06/2022.
//

import XCTest
@testable import ForSale

class ListOffersInteractorTests: XCTestCase {

    var sut: ListOffersInteractor!
    var workerMock: ListOffersWorkerMock!
    var presenterMock: ListOffersPresenterMock!
    let dummyOffer1 = Offer(id: 1, title: "", categoryId: 11, description: "", price: 0,
                            imagesUrl: nil, creationDate: Date(), isUrgent: false, siret: nil)
    let dummyOffer2 = Offer(id: 2, title: "", categoryId: 12, description: "", price: 0,
                            imagesUrl: nil, creationDate: Date(), isUrgent: false, siret: nil)
    let dummyCategory1 = OfferCategory(id: 11, name: "")
    let dummyCategory2 = OfferCategory(id: 12, name: "")

    override func setUpWithError() throws {
        sut = ListOffersInteractor()
        workerMock = ListOffersWorkerMock(store: OffersAPI())
        presenterMock = ListOffersPresenterMock()
        sut.worker = workerMock
        sut.presenter = presenterMock
    }

    override func tearDownWithError() throws {
        sut = nil
        workerMock = nil
        presenterMock = nil
    }

    func test_fetchOffersShouldTellWorkerToFetchCategories() async {
        await sut.fetchOffers()

        XCTAssertTrue(workerMock.fetchCategoriesCalled)
    }

    func test_fetchOffersShouldTellWorkerToFetchOffers() async {
        await sut.fetchOffers()

        XCTAssertTrue(workerMock.fetchOffersCalled)
    }

    func test_fetchOffersWithoutError_shouldTellPresenterToPresentResponse() async {
        await sut.fetchOffers()

        XCTAssertTrue(presenterMock.presentResponseCalled)
        XCTAssertFalse(presenterMock.presentErrorMessageCalled)
    }

    func test_fetchCategoriesWithError_shouldTellPresenterToPresentError() async {
        workerMock.fetchCategoriesError = NSError(domain: "", code: 1234)

        await sut.fetchOffers()

        XCTAssertFalse(presenterMock.presentResponseCalled)
        XCTAssertTrue(presenterMock.presentErrorMessageCalled)
    }

    func test_fetchOffersWithError_shouldTellPresenterToPresentError() async {
        workerMock.fetchOffersError = NSError(domain: "", code: 1234)

        await sut.fetchOffers()

        XCTAssertFalse(presenterMock.presentResponseCalled)
        XCTAssertTrue(presenterMock.presentErrorMessageCalled)
    }
    
    func test_fetchCategoriesWithOneResult_shouldReturnOneCategory() async {
        workerMock.fetchCategoriesData = [dummyCategory1]

        await sut.fetchOffers()

        XCTAssertEqual(sut.categories.count, 1)
    }

    func test_fetchCategoriesWithTwoResults_shouldReturnTwoCategories() async {
        workerMock.fetchCategoriesData = [
            dummyCategory1,
            dummyCategory2
        ]

        await sut.fetchOffers()

        XCTAssertEqual(sut.categories.count, 2)
    }

    func test_fetchOffersWithOneResult_shouldReturnOneOffer() async {
        workerMock.fetchOffersData = [dummyOffer1]

        await sut.fetchOffers()

        XCTAssertEqual(sut.offers.count, 1)
    }

    func test_fetchOffersWithTwoResults_shouldReturnTwoOffers() async {
        workerMock.fetchOffersData = [
            dummyOffer1,
            dummyOffer2
        ]

        await sut.fetchOffers()

        XCTAssertEqual(sut.offers.count, 2)
    }
}
