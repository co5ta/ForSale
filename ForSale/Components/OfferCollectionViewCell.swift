//
//  OfferCollectionViewCell.swift
//  ForSale
//
//  Created by costa.monzili on 28/06/2022.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    var mainStackView = UIStackView()
    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

private extension OfferCollectionViewCell {
    func setUp() {
        setUpStackView()
        setUpTitleLabel()
    }

    func setUpStackView() {
        contentView.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setUpTitleLabel() {
        mainStackView.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 0
    }
}
