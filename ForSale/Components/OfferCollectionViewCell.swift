//
//  OfferCollectionViewCell.swift
//  ForSale
//
//  Created by costa.monzili on 28/06/2022.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    var offerSummaryView = OfferSummaryView.instantiate(fullScreen: true)

    override func prepareForReuse() {
        super.prepareForReuse()
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

    func configure(with offer: ListOffers.FetchOffers.ViewModel.Offer) {
        offerSummaryView.configure(with: offer)
    }

    private func setUp() {
        setUpViewHierarchy()
        setUpOfferSummaryView()
    }

    func setUpViewHierarchy() {
        contentView.addSubview(offerSummaryView)
    }

    func setUpOfferSummaryView() {
        offerSummaryView.imageView.layer.cornerRadius = 10
        offerSummaryView.imageView.layer.borderColor = UIColor.systemGray6.cgColor
        offerSummaryView.imageView.layer.borderWidth = 1
        offerSummaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offerSummaryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            offerSummaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            offerSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            offerSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
