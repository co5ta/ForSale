//
//  ShowOfferRouter.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import Foundation

protocol AnyShowOfferRouter {}

protocol AnyShowOfferDataPassing {
    var dataStore: AnyShowOfferDataStore? { get }
}

class ShowOfferRouter: NSObject, AnyShowOfferRouter, AnyShowOfferDataPassing {
    weak var viewController: ShowOfferViewController?
    var dataStore: AnyShowOfferDataStore?
}
