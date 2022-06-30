//
//  ListOffersPresenter.swift
//  ForSale
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation

protocol AnyListOffersPresenter {
    func present(response: ListOffers.FetchOffers.Response) async
    func present(errorMessage: String) async
}

@MainActor
class ListOffersPresenter: AnyListOffersPresenter {
    weak var viewController: AnyListOffersViewController?

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fr-FR")
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    func present(response: ListOffers.FetchOffers.Response) async {
        let viewModelOffers = getViewModelOffers(from: response)
        let viewModel = ListOffers.FetchOffers.ViewModel(offers: viewModelOffers)
        viewController?.displayOffers(from: viewModel)
    }

    func getViewModelOffers(from response: ListOffers.FetchOffers.Response) -> [ListOffers.FetchOffers.ViewModel.Offer] {
        return response.offers.map { offer in
            let category = response.categories.first(where: { $0.id == offer.categoryId })
            let price = NSNumber(value: offer.price)

            return ListOffers.FetchOffers.ViewModel.Offer(
                id: offer.id,
                title: offer.title,
                categoryName: category?.name,
                price: numberFormatter.string(from: price),
                date: dateFormatter.string(from: offer.creationDate),
                imagePath: offer.imagesUrl?.thumb,
                isUrgent: offer.isUrgent
            )
        }
    }

    func present(errorMessage: String) async {
        viewController?.display(errorMessage: errorMessage)
    }
}
