//
//  ListOffersViewController.swift
//  ForSale
//
//  Created by costa.monzili on 28/06/2022.
//

import UIKit
import Combine

protocol AnyListOffersViewController: AnyObject {
    func displayOffers(from viewModel: ListOffers.FetchOffers.ViewModel)
    func display(errorMessage: String)
}

class ListOffersViewController: UIViewController, AnyListOffersViewController {
    var interactor: AnyListOffersInteractor?
    var router: (AnyListOffersRouter & AnyListOffersDataPassing)?
    var viewModel: ListOffers.FetchOffers.ViewModel?
    lazy var collectionView = makeCollectionView()
    var offers = CurrentValueSubject<[ListOffers.FetchOffers.ViewModel.Offer], Never>([])
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DataSource?
    private var menuButton: UIBarButtonItem?
    private var categoriesMenu: UIMenu?
    private var selectedCategoryId: Int?
    var selectedOfferIndex: Int?
    /// True if the trait collection horizontal size class is Compact
    lazy var isCompact: Bool = traitCollection.horizontalSizeClass == .compact

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

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOffersList()
        Task {
            await fetchOffers()
        }
    }

    private func setUpVIP() {
        let viewController = self
        let interactor = ListOffersInteractor()
        let presenter = ListOffersPresenter()
        let router = ListOffersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func setUpViews() {
        title = "Annonces"
        let backButton = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchOffers() async {
        await interactor?.fetchOffers()
    }

    func displayOffers(from viewModel: ListOffers.FetchOffers.ViewModel) {
        self.viewModel = viewModel
        offers.value = viewModel.offers
    }

    func display(errorMessage: String) {
        let alert = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
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
            cell.configure(with: offer)
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
        snapshot.appendItems(offers.value)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(isCompact ? 1.0 : 0.5),
            heightDimension: .estimated(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func makeCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    }

    func bindOffersList() {
        offers.sink { [weak self] _ in
            guard let self = self else { return }
            self.dataSource = self.makeDataSource()
            self.applySnapshot()
            self.makeMenu()
        }
        .store(in: &cancellables)
    }
}

// MARK: - CollectionViewDelegate

extension ListOffersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedOfferIndex = indexPath.item
        router?.routeToShowOffer()
    }
}

// MARK: - Categories filter

private extension ListOffersViewController {
    func makeMenu() {
        categoriesMenu = UIMenu(
            title: "Filtrer par catégorie",
            options: .displayInline,
            children: createMenuItems())
        menuButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: categoriesMenu)
        navigationItem.setRightBarButton(menuButton, animated: true)
    }

    func createMenuItems() -> [UIAction] {
        guard let categories = viewModel?.categories else { return [] }
        var items = categories.map { category -> UIAction in
            let state: UIMenuElement.State = selectedCategoryId == category.id ? .on : .off
            return UIAction(title: category.name, state: state) { [weak self] _ in
                self?.applyOffersFilter(categoryId: category.id)
            }
        }
        if selectedCategoryId != nil {
            items.insert(UIAction(
                title: "Réinitialiser",
                image: UIImage(systemName: "x.circle"),
                attributes: .destructive) { [weak self] _ in
                self?.applyOffersFilter(categoryId: nil)
            }, at: 0)
        }
        return items
    }

    func applyOffersFilter(categoryId: Int?) {
        guard let viewModel = viewModel,
              categoryId != selectedCategoryId
        else { return }
        selectedCategoryId = categoryId
        offers.value = categoryId == nil
            ? viewModel.offers
            : viewModel.offers.filter { $0.categoryId == categoryId }
    }
}
