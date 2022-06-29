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

class ListOffersViewController: UIViewController, AnyListOffersViewController {
    lazy var collectionView = makeCollectionView()

    private var dataSource: DataSource?
    var offers: [ListOffers.FetchOffers.ViewModel.Offer] = []
    var interactor: AnyListOffersInteractor?

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
        let interactor = ListOffersInteractor()
        let presenter = ListOffersPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    private func setUpViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchOffers()
        }
    }

    func fetchOffers() async {
        await interactor?.fetchOffers()
    }

    func displayOffers(from viewModel: ListOffers.FetchOffers.ViewModel) {
        offers = viewModel.offers
        dataSource = makeDataSource()
        applySnapshot()
    }

    func display(errorMessage: String) {
        print("erreur")
    }
}


// MARK: - CollectionView

private extension ListOffersViewController {
    typealias CellRegistration = UICollectionView.CellRegistration<OfferCollectionViewCell, ListOffers.FetchOffers.ViewModel.Offer>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListOffers.FetchOffers.ViewModel.Offer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ListOffers.FetchOffers.ViewModel.Offer>

    enum Section {
        case main
    }

    enum Constants {
        static let cellSpacing: CGFloat = 20
    }

    func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, offer in
            cell.titleLabel.text = offer.title
        }
    }

    func makeDataSource() -> DataSource {
        let cellRegistration = makeCellRegistration()
        return DataSource(collectionView: collectionView) { collectionView, indexPath, offer in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: offer)
        }
    }

    func applySnapshot(animate: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(offers)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.cellSpacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func makeCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    }
}
