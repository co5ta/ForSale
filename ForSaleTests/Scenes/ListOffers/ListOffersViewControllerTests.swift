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
    let dummyOffer1 = ListOffers.FetchOffers.ViewModel.Offer(
        id: 1, title: "title 1", categoryId: 11, categoryName: "categ 1",
        price: "14.00 €", date: "05/01/2022", imagePath: "", isUrgent: false)
    let dummyOffer2 = ListOffers.FetchOffers.ViewModel.Offer(
        id: 2, title: "title 2", categoryId: 12, categoryName: "categ 2",
        price: "18,00 €", date: "18/12/2022", imagePath: "", isUrgent: true)


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
        XCTAssertTrue(sut.collectionView.isDescendant(of: sut.view))
    }

    func test_numberOfItems_whenOneOfferFetched_shouldReturnOne() {
        let offers = [
            dummyOffer1
        ]

        let viewModel = ListOffers.FetchOffers.ViewModel(categories: [], offers: offers)
        sut.displayOffers(from: viewModel)

        let result = sut.collectionView.numberOfItems(inSection: 0)
        XCTAssertEqual(result, 1)
    }

    func test_numberOfItems_whenTwoOffersFetched_shouldReturnTwo() {
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]

        let viewModel = ListOffers.FetchOffers.ViewModel(categories: [], offers: offers)
        sut.displayOffers(from: viewModel)

        let result = sut.collectionView.numberOfItems(inSection: 0)
        XCTAssertEqual(result, 2)
    }

    func test_cellForRowAt_shouldReturnOffersData() throws {
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]

        let viewModel = ListOffers.FetchOffers.ViewModel(categories: [], offers: offers)
        sut.displayOffers(from: viewModel)

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = try XCTUnwrap(
            sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
            as? OfferCollectionViewCell)
        let offerSummaryView = cell.offerSummaryView

        XCTAssertEqual(offerSummaryView.titleLabel.text, dummyOffer1.title)
        XCTAssertEqual(offerSummaryView.categoryLabel.text, dummyOffer1.categoryName)
        XCTAssertEqual(offerSummaryView.dateLabel.text, dummyOffer1.date)
        XCTAssertEqual(offerSummaryView.priceLabel.text, dummyOffer1.price)
        XCTAssertTrue(offerSummaryView.urgentLabel.isHidden)
    }

    func test_cellForRowAt_shouldReturnOffersData2() throws {
        let offers = [
            dummyOffer1,
            dummyOffer2
        ]

        let viewModel = ListOffers.FetchOffers.ViewModel(categories: [], offers: offers)
        sut.displayOffers(from: viewModel)

        let indexPath = IndexPath(item: 1, section: 0)
        let cell = try XCTUnwrap(
            sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: indexPath)
            as? OfferCollectionViewCell)
        let offerSummaryView = cell.offerSummaryView

        XCTAssertEqual(offerSummaryView.titleLabel.text, dummyOffer2.title)
        XCTAssertEqual(offerSummaryView.categoryLabel.text, dummyOffer2.categoryName)
        XCTAssertEqual(offerSummaryView.dateLabel.text, dummyOffer2.date)
        XCTAssertEqual(offerSummaryView.priceLabel.text, dummyOffer2.price)
        XCTAssertFalse(offerSummaryView.urgentLabel.isHidden)
    }
}
