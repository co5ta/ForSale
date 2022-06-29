//
//  OffersAPITests.swift
//  ForSaleTests
//
//  Created by costa.monzili on 27/06/2022.
//

import XCTest
@testable import ForSale

class OffersAPITests: XCTestCase {

    var sut: OffersAPI!
    var sessionMock: URLSessionMock!
    var dummyURL: URL!
    let dummyOffer1 = Offer(id: 1, title: "", categoryId: 11)
    let dummyOffer2 = Offer(id: 2, title: "", categoryId: 12)
    let dummyCategory1 = OfferCategory(id: 11, name: "")
    let dummyCategory2 = OfferCategory(id: 12, name: "")

    override func setUpWithError() throws {
        sut = OffersAPI()
        sessionMock = URLSessionMock()
        sut.session = sessionMock
        dummyURL = try XCTUnwrap(URL(string: "dummyUrl"))
    }

    override func tearDownWithError() throws {
        sut = nil
        sessionMock = nil
        dummyURL = nil
    }

    func test_fetchCategories_shouldReturnCategories() async throws {
        let expected = [
            dummyCategory1,
            dummyCategory2
        ]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(expected),
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil)!
        )

        let categories = try await sut.fetchCategories()
        XCTAssertEqual(categories, expected)
    }

    func test_fetchOffers_shouldReturnOffers() async throws {
        let expected = [
            dummyOffer1,
            dummyOffer2
        ]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(expected),
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil)!
        )

        let offers = try await sut.fetchOffers()
        XCTAssertEqual(offers, expected)
    }

    func test_fetchCategoriesWithError_shouldPassError() async throws {
        let expected = NSError(domain: "", code: 1234)
        sessionMock.urlSessionError = expected
        let categories = [dummyCategory1]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(categories),
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil)!
        )

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
        sessionMock.urlSessionError = expected
        let offers = [dummyOffer1]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(offers),
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil)!
        )

        do {
            _ = try await sut.fetchOffers()
            XCTFail()
        } catch {
            let nsError = try XCTUnwrap(error as NSError)
            XCTAssertEqual(nsError, expected)
        }
    }

    func test_fetchOffers_whenResponseIsUnder200_shouldPassServerError() async throws {
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 199,
                httpVersion: "HTTP/1.1",
                headerFields: nil))
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(offers),
            response)

        do {
            _ = try await sut.fetchOffers()
            XCTFail()
        } catch {
            let networkError = try XCTUnwrap(error as? NetworkError)
            XCTAssertEqual(networkError, NetworkError.server(response))
        }
    }

    func test_fetchOffers_whenResponseIsAbove299_shouldPassServerError() async throws {
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: dummyURL,
                statusCode: 300,
                httpVersion: "HTTP/1.1",
                headerFields: nil))
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]
        sessionMock.urlSessionResult = (
            try JSONEncoder().encode(offers),
            response)

        do {
            _ = try await sut.fetchOffers()
            XCTFail()
        } catch {
            let networkError = try XCTUnwrap(error as? NetworkError)
            XCTAssertEqual(networkError, NetworkError.server(response))
        }
    }

    func test_fetchOffers_whenJsonIsWrong_shouldPassDecodingError() async throws {
        sessionMock.urlSessionResult = (
          try JSONEncoder().encode("dummy"),
          HTTPURLResponse(url: dummyURL,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: nil)!
        )

        do {
          _ = try await sut.fetchOffers()
          XCTFail()
        } catch {
          XCTAssertTrue(error is Swift.DecodingError)
        }
    }
}
