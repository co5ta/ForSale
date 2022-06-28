//
//  ListOffersPresenter.swift
//  ForSale
//
//  Created by costa.monzili on 25/06/2022.
//

import Foundation

protocol AnyListOffersPresenter {
    func present(response: ListOffers.FetchOffers.Response)
    func present(errorMessage: String)
}

class ListOffersPresenter: AnyListOffersPresenter {
    weak var viewController: AnyListOffersViewController?

    func present(response: ListOffers.FetchOffers.Response) {
        let viewModelOffers = getViewModelOffers(from: response)
        let viewModel = ListOffers.FetchOffers.ViewModel(offers: viewModelOffers)
        viewController?.displayOffers(from: viewModel)
    }

    func getViewModelOffers(from response: ListOffers.FetchOffers.Response) -> [ListOffers.FetchOffers.ViewModel.Offer] {
        return response.offers.map { offer in
            let category = response.categories.first(where: { $0.id == offer.idCategory })
            
            return ListOffers.FetchOffers.ViewModel.Offer(
                title: offer.title,
                categoryName: category?.title
            )
        }
    }

    func present(errorMessage: String) {
        viewController?.display(errorMessage: errorMessage)
    }
}
