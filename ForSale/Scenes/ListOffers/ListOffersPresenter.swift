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
