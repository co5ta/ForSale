//
//  ShowOfferInteractor.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import Foundation

protocol AnyShowOfferInteractor {
    func getOffer()
}

protocol AnyShowOfferDataStore {
    var offer: Offer? { get set }
    var category: OfferCategory? { get set }
}

class ShowOfferInteractor: AnyShowOfferInteractor, AnyShowOfferDataStore {
    var presenter: ShowOfferPresenter?
    var offer: Offer?
    var category: OfferCategory?

    func getOffer() {
        guard let offer = offer, let category = category else { return }
        let response = ShowOffer.GetOffer.Response(category: category, offer: offer)
        presenter?.present(response: response)
    }
}
