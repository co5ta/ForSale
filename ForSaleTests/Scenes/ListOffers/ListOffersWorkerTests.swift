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
            OfferCategory(id: 1, title: ""),
            OfferCategory(id: 2, title: "")
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
            Offer(id: 1, title: ""),
            Offer(id: 2, title: "")
        ]

        do {
            let offers = try await sut.fetchOffers()
            XCTAssertEqual(offers.count, 2)
        } catch {
            XCTFail()
        }
    }
}
