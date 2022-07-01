//
//  OfferCollectionViewCell.swift
//  ForSale
//
//  Created by costa.monzili on 28/06/2022.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    var offerSummaryView = OfferSummaryView()

    override func prepareForReuse() {
        offerSummaryView.imageView.image = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    func configure(with offer: ListOffers.FetchOffers.ViewModel.Offer, store: AnyOfferStore) {
        offerSummaryView.configure(with: offer, store: store)
    }

    private func setUp() {
        contentView.addSubview(offerSummaryView)
        offerSummaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offerSummaryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            offerSummaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            offerSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            offerSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
