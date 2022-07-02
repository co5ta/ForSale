//
//  OfferSummaryView.swift
//  ForSale
//
//  Created by costa.monzili on 29/06/2022.
//

import UIKit

protocol AnyOffer {
    var id: Int { get }
    var title: String { get }
    var categoryId: Int { get }
    var categoryName: String? { get }
    var price: String? { get }
    var date: String? { get }
    var imagePath: String? { get }
    var isUrgent: Bool { get }
}

class OfferSummaryView: UIView {
    var mainStackView = UIStackView()
    var imageView = UIImageView()
    var summaryView = UIView()
    var summaryStackView = UIStackView()
    var titleLabel = UILabel()
    var urgentLabel = UILabel()
    var urgentImageView = UIImageView()
    var categoryLabel = UILabel()
    var priceLabel = UILabel()
    var dateLabel = UILabel()

    /// True if the trait collection horizontal size class is Compact
    lazy var isCompact: Bool = traitCollection.horizontalSizeClass == .compact
    /// True if the view need to take all screen width
    private var fullScreen: Bool? {
        didSet { setUp() }
    }

    /// Instantiates the view with a fullscreen value
    static func instantiate(fullScreen: Bool) -> OfferSummaryView {
        let view = OfferSummaryView()
        view.fullScreen = fullScreen
        return view
    }

    func setUp() {
        setUpViewHierarchy()
        setUpStackView()
        setUpImageView()
        setUpSummaryStackView()
        setUpTitleLabel()
        setUpUrgentLabel()
        setUpUrgentImageView()
        setUpOthersViews()
    }

    func configure(with offer: AnyOffer, store: AnyOfferStore) {
        imageView.image = UIImage(named: "placeholder-image")
        titleLabel.text = offer.title
        priceLabel.text = offer.price
        dateLabel.text = offer.date
        categoryLabel.text = offer.categoryName
        urgentLabel.isHidden = !offer.isUrgent
        urgentImageView.isHidden = !offer.isUrgent

        Task {
            guard let imagePath = offer.imagePath,
                  let image = await store.fetchImage(path: imagePath)
            else { return }
            imageView.image = image
        }
    }
}

private extension OfferSummaryView {
    func setUpViewHierarchy() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(summaryView)
        summaryView.addSubview(summaryStackView)
        summaryStackView.addArrangedSubview(titleLabel)
        summaryStackView.addArrangedSubview(urgentLabel)
        summaryStackView.addArrangedSubview(categoryLabel)
        summaryStackView.addArrangedSubview(priceLabel)
        summaryStackView.addArrangedSubview(dateLabel)
        addSubview(urgentImageView)
    }

    func setUpStackView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setUpImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: fullScreen == true ? 0.65 : 0.8)
        ])
    }

    func setUpSummaryStackView() {
        summaryStackView.axis = .vertical
        summaryStackView.spacing = 5
        summaryStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryStackView.topAnchor.constraint(equalTo: summaryView.topAnchor),
            summaryStackView.bottomAnchor.constraint(equalTo: summaryView.bottomAnchor),
            summaryStackView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: fullScreen == true ? 0 : 10),
            summaryStackView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: fullScreen == true ? 0 : -10)
        ])
    }

    func setUpTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: isCompact ? .headline : .title2)
        titleLabel.numberOfLines = 0
    }

    func setUpUrgentLabel() {
        urgentLabel.font = .preferredFont(forTextStyle: isCompact ? .subheadline : .body)
        urgentLabel.textColor = .systemRed
        urgentLabel.text = "Urgent"
    }

    func setUpUrgentImageView() {
        urgentImageView.image = UIImage(named: "warn")
        urgentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urgentImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            urgentImageView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: isCompact ? -5 : -10),
            urgentImageView.heightAnchor.constraint(equalToConstant: isCompact ? 30 : 40),
            urgentImageView.widthAnchor.constraint(equalTo: urgentImageView.heightAnchor)
        ])
    }

    func setUpOthersViews() {
        priceLabel.font = .preferredFont(forTextStyle: .title3)
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
    }
}
