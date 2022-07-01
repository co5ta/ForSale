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
        let viewModelCategories = getViewModelCategories(from: response)
        let viewModel = ListOffers.FetchOffers.ViewModel(categories: viewModelCategories, offers: viewModelOffers)
        viewController?.displayOffers(from: viewModel)
    }

    func getViewModelOffers(from response: ListOffers.FetchOffers.Response)
    -> [ListOffers.FetchOffers.ViewModel.Offer] {
        return response
            .offers
            .sortedByDate()
            .map { offer in
                let category = response.categories.first(where: { $0.id == offer.categoryId })
                return createViewModelOffer(with: offer, and: category)
            }
    }

    func getViewModelCategories (from response: ListOffers.FetchOffers.Response)
    -> [ListOffers.FetchOffers.ViewModel.Category] {
        return response
            .categories
            .map {
                ListOffers.FetchOffers.ViewModel.Category(id: $0.id, name: $0.name)
            }
    }

    func createViewModelOffer(with offer: Offer, and category: OfferCategory?)
    -> ListOffers.FetchOffers.ViewModel.Offer {
        let price = NSNumber(value: offer.price)
        return ListOffers.FetchOffers.ViewModel.Offer(
            id: offer.id,
            title: offer.title,
            categoryId: offer.categoryId,
            categoryName: category?.name,
            price: numberFormatter.string(from: price),
            date: dateFormatter.string(from: offer.creationDate),
            imagePath: offer.imagesUrl?.thumb,
            isUrgent: offer.isUrgent)
    }

    func present(errorMessage: String) async {
        viewController?.display(errorMessage: errorMessage)
    }
}
