//
//  ShowOfferViewController.swift
//  ForSale
//
//  Created by costa.monzili on 01/07/2022.
//

import UIKit

protocol AnyShowOfferViewController: AnyObject {
    func displayOffer(from viewModel: ShowOffer.GetOffer.ViewModel)
}

class ShowOfferViewController: UIViewController, AnyShowOfferViewController {

    var interactor: AnyShowOfferInteractor?
    var router: (AnyShowOfferRouter & AnyShowOfferDataPassing)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }

    private func setUp() {
        setUpVIP()
        setUpViews()
    }

    private func setUpVIP() {
      let viewController = self
      let interactor = ShowOfferInteractor()
      let presenter = ShowOfferPresenter()
      let router = ShowOfferRouter()
      viewController.interactor = interactor
      viewController.router = router
      interactor.presenter = presenter
      presenter.viewController = viewController
      router.viewController = viewController
      router.dataStore = interactor
    }

    private func setUpViews() {
        view.backgroundColor = .systemRed
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func displayOffer(from viewModel: ShowOffer.GetOffer.ViewModel) {

    }
}
