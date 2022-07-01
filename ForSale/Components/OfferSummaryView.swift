//
//  OfferSummaryView.swift
//  ForSale
//
//  Created by costa.monzili on 29/06/2022.
//

import UIKit

class OfferSummaryView: UIView {
    var mainStackView = UIStackView()
    var categoryLabel = UILabel()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var summaryContainerView = UIView()
    var summaryStackView = UIStackView()
    var priceLabel = UILabel()
    var dateLabel = UILabel()
    var urgentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    func configure(with offer: ListOffers.FetchOffers.ViewModel.Offer, store: AnyOfferStore) {
        imageView.image = UIImage(named: "placeholder-image")
        titleLabel.text = offer.title
        priceLabel.text = offer.price
        dateLabel.text = offer.date
        categoryLabel.text = offer.categoryName
        urgentLabel.isHidden = !offer.isUrgent

        Task {
            guard let imagePath = offer.imagePath,
                  let image = await store.fetchImage(path: imagePath)
            else { return }
            imageView.image = image
        }
    }

    func configure(with offer: ShowOffer.GetOffer.ViewModel.Offer, store: AnyOfferStore) {
        imageView.image = UIImage(named: "placeholder-image")
        titleLabel.text = offer.title
        priceLabel.text = offer.price
        dateLabel.text = offer.date
        categoryLabel.text = offer.categoryName
        urgentLabel.isHidden = !offer.isUrgent

        Task {
            guard let imagePath = offer.imagePath,
                  let image = await store.fetchImage(path: imagePath)
            else { return }
            imageView.image = image
        }
    }
    
    func setUp() {
        setUpStackView()
        setUpImageView()
        setUpTitleLabel()
        setUpSummaryStackView()
    }
}

private extension OfferSummaryView {
    func setUpStackView() {
        addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 2),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(summaryContainerView)
    }

    func setUpTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
    }

    func setUpImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.5)
        ])
    }

    func setUpSummaryStackView() {
        summaryContainerView.addSubview(summaryStackView)

        summaryStackView.axis = .vertical
        summaryStackView.spacing = 5

        summaryStackView.addArrangedSubview(titleLabel)

        summaryStackView.addArrangedSubview(urgentLabel)
        urgentLabel.font = .preferredFont(forTextStyle: .subheadline)
        urgentLabel.textColor = .systemRed
        urgentLabel.text = "Urgent"

        summaryStackView.addArrangedSubview(categoryLabel)

        summaryStackView.addArrangedSubview(priceLabel)
        priceLabel.font = .preferredFont(forTextStyle: .callout)

        summaryStackView.addArrangedSubview(dateLabel)
        dateLabel.font = .preferredFont(forTextStyle: .caption1)

        summaryStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryStackView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor),
            summaryStackView.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 10),
            summaryStackView.trailingAnchor.constraint(equalTo: summaryContainerView.trailingAnchor, constant: -10)
        ])
    }
}
