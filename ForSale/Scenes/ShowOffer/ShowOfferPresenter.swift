//
//  ShowOfferPresenter.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import Foundation

protocol AnyShowOfferPresenter {
    func present(response: ShowOffer.GetOffer.Response)
}

class ShowOfferPresenter {
    weak var viewController: AnyShowOfferViewController?

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

    func present(response: ShowOffer.GetOffer.Response) {
        let viewModelOffer = createViewModelOffer(with: response.offer, and: response.category)
        let viewModel = ShowOffer.GetOffer.ViewModel(offer: viewModelOffer)
        viewController?.displayOffer(from: viewModel)
    }

    func createViewModelOffer(with offer: Offer, and category: OfferCategory?)
    -> ShowOffer.GetOffer.ViewModel.Offer {
        let price = NSNumber(value: offer.price)
        return ShowOffer.GetOffer.ViewModel.Offer(
            id: offer.id,
            title: offer.title,
            categoryId: offer.categoryId,
            categoryName: category?.name,
            price: numberFormatter.string(from: price),
            date: dateFormatter.string(from: offer.creationDate),
            imagePath: offer.imagesUrl?.thumb,
            isUrgent: offer.isUrgent,
            description: offer.description,
            siret: offer.siret)
    }
}
