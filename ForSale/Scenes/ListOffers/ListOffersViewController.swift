//
//  ListOffersViewController.swift
//  ForSale
//
//  Created by costa.monzili on 28/06/2022.
//

import UIKit

protocol AnyListOffersViewController: AnyObject {
    func displayOffers(from viewModel: ListOffers.FetchOffers.ViewModel)
    func display(errorMessage: String)
}
