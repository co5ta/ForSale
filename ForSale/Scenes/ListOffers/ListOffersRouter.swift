//
//  ListOffersRouter.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import Foundation
import UIKit

@objc protocol AnyListOffersRouter {
    func routeToShowOffer()
}

protocol AnyListOffersDataPassing {
    var dataStore: AnyListOffersDataStore? { get }
}

class ListOffersRouter: NSObject, AnyListOffersRouter, AnyListOffersDataPassing {
    weak var viewController: ListOffersViewController?
    var dataStore: AnyListOffersDataStore?

    func routeToShowOffer() {
        let destinationVC = ShowOfferViewController()
        guard let dataStore = dataStore, var destinationDS = destinationVC.router?.dataStore
        else { return }
        passDataToShowOffer(source: dataStore, destination: &destinationDS)
        navigateToShowOffer(source: viewController!, destination: destinationVC)
    }

    func passDataToShowOffer(source: AnyListOffersDataStore, destination: inout AnyShowOfferDataStore) {
        guard let itemIndex = viewController?.collectionView.indexPathsForSelectedItems?.first?.row
        else { return }
        destination.offer = source.offers[itemIndex]
    }

    func navigateToShowOffer(source: ListOffersViewController, destination: ShowOfferViewController) {
        source.show(destination, sender: nil)
    }
}
