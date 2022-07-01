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
    var scrollView = UIScrollView()
    var mainStackView = UIStackView()
    var offerSummaryView = OfferSummaryView()
    var descriptionLabel = UILabel()
    var siretLabel = UILabel()

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
    
    override func viewWillAppear(_ animated: Bool) {
        getOffer()
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
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.addSubview(mainStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.addArrangedSubview(offerSummaryView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        offerSummaryView.summaryStackView.addArrangedSubview(descriptionLabel)
        offerSummaryView.summaryStackView.setCustomSpacing(20, after: offerSummaryView.dateLabel)
        descriptionLabel.font = .preferredFont(forTextStyle: .callout)
        descriptionLabel.numberOfLines = 0

        offerSummaryView.summaryStackView.addArrangedSubview(siretLabel)
        siretLabel.font = .preferredFont(forTextStyle: .footnote)
    }

    func getOffer() {
        interactor?.getOffer()
    }

    func displayOffer(from viewModel: ShowOffer.GetOffer.ViewModel) {
        let offer = viewModel.offer
        offerSummaryView.configure(with: offer, store: OffersAPI())
        descriptionLabel.text = offer.description
        if let siret = offer.siret {
            siretLabel.text = "Siret: \(siret)"
        }
    }
}
