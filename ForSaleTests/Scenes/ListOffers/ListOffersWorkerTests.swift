//
//  ListOffersWorkerTests.swift
//  ForSaleTests
//
//  Created by costa.monzili on 27/06/2022.
//

import XCTest
@testable import ForSale

class ListOffersWorkerTests: XCTestCase {

    var sut: ListOffersWorker!
    var storeMock: OffersAPIMock!
    let dummyOffer1 = Offer(id: 1, title: "", categoryId: 11)
    let dummyOffer2 = Offer(id: 2, title: "", categoryId: 12)
    let dummyCategory1 = OfferCategory(id: 11, name: "")
    let dummyCategory2 = OfferCategory(id: 12, name: "")

    override func setUpWithError() throws {
        sut = ListOffersWorker(store: OffersAPI())
        storeMock = OffersAPIMock()
        sut.store = storeMock
    }

    override func tearDownWithError() throws {
        sut = nil
        storeMock = nil
    }

    func test_fetchCategories_shouldTellStoreToFetchCategories() async throws {
        _ = try await sut.fetchCategories()
        XCTAssertTrue(storeMock.fetchCategoriesCalled)
    }

    func test_fetchOffers_shouldTellStoreToFetchOffers() async throws {
        _ = try await sut.fetchOffers()
        XCTAssertTrue(storeMock.fetchOffersCalled)
    }

    func test_fetchCategoriesWithError_shouldPassError() async throws {
        let expected = NSError(domain: "", code: 1234)
        storeMock.fetchCategoriesError = expected

        do {
            _ = try await sut.fetchCategories()
            XCTFail()
        } catch {
            let nsError = try XCTUnwrap(error as NSError)
            XCTAssertEqual(nsError, expected)
        }
    }

    func test_fetchOffersWithError_shouldPassError() async throws {
        let expected = NSError(domain: "", code: 1234)
        storeMock.fetchOffersError = expected

        do {
            _ = try await sut.fetchOffers()
            XCTFail()
        } catch {
            let nsError = try XCTUnwrap(error as NSError)
            XCTAssertEqual(nsError, expected)
        }
    }

    func test_fetchCategoriesWithoutError_shouldReturnCategories() async {
        storeMock.fetchCategoriesData = [
            dummyCategory1,
            dummyCategory2
        ]

        do {
            let categories = try await sut.fetchCategories()
            XCTAssertEqual(categories.count, 2)
        } catch {
            XCTFail()
        }
    }

    func test_fetchOffersWhithoutError_shouldReturnOffers() async {
        storeMock.fetchOffersData = [
            dummyOffer1,
            dummyOffer2
        ]

        do {
            let offers = try await sut.fetchOffers()
            XCTAssertEqual(offers.count, 2)
        } catch {
            XCTFail()
        }
    }
}
