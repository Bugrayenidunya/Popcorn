//
//  HomeController.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 26.04.2022.
//

import UIKit

// MARK: - HomeController
final class HomeController: UIViewController {
    
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    
    // MARK: Properties
    private var sections = Section.allSections
    private var viewModel: HomeViewModelInput
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    
    private enum Constant {
        static let headerKind = "header"
        static let sectionInset = 2.0
        static let quarter = 0.25
        static let half = 0.5
        static let full = 1.0
        static let headerHeight = 44.0
    }
    
    // MARK: Views
    private lazy var collectionView: UICollectionView = {
        let compositionalLayout = generateCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.identifier
        )
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.viewDidLoad()
        applySnapshot(animatingDifferences: false)
    }
    
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
        
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, cellDidLoad cell: [HomeCollectionViewCellViewModel]) {
        DispatchQueue.main.async {
            self.sections = [Section(title: "Deneme", photos: cell)]
            self.applySnapshot(animatingDifferences: true)
        }
    }
    
    func home(_ viewModel: HomeViewModelInput, photoDidLoad photo: [Photo]) {
        // TODO: Implement
    }
    
    func home(_ viewModel: HomeViewModelInput, albumListDidLoad list: [Album]) {
        list.forEach { album in
            viewModel.retrievePhotos(for: album)
        }
    }
    
    func home(_ viewModel: HomeViewModelInput, userListDidLoad list: [User]) {
        list.forEach { user in
            viewModel.retrieveAlbums(for: user)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
    
}

// MARK: - Helpers
private extension HomeController {
    func setupView() {
        view.addSubview(collectionView)
        
        collectionView.setConstarint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero
        )
    }
    /// Applies new data to dataSource
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.photos, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    /// Generates `UICollectionViewDiffableDataSource`
    func generateDatasource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                    return .init(frame: .zero)
                }
                
                cell.configure(with: cellViewModel)
                
                return cell
            })

        return dataSource
    }
    /// Setups `Section`
    func setupSupplementryView() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            // TODO: Implement section header
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            return view
        }
    }
    
    /// Generates `UICollectionViewCompositionalLayout` with given items, group, header and section
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let (smallItem, largeItem) = generateLayoutItems()
        
        // Inner Group
        let innerGroupDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.quarter),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupDimension, subitems: [smallItem])
        
        // Outer Group
        let outerGroupDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .fractionalWidth(Constant.half)
        )
        
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupDimension, subitems: [largeItem, innerGroup, innerGroup])
        
        return .init(section: generateSection(for: outerGroup))
    }
    /// Generates `NSCollectionLayoutItem` with given dimensions
    func generateLayoutItems() -> (small: NSCollectionLayoutItem, large: NSCollectionLayoutItem) {
        // Small Item
        let smallItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .fractionalHeight(Constant.half)
        )
        
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemDimension)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: Constant.sectionInset, leading: Constant.sectionInset, bottom: Constant.sectionInset, trailing: Constant.sectionInset)
        
        // Large Item
        let largeItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.half),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemDimension)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: Constant.sectionInset, leading: Constant.sectionInset, bottom: Constant.sectionInset, trailing: Constant.sectionInset)
        
        return (smallItem, largeItem)
    }
    /// Generates `NSCollectionLayoutBoundarySupplementaryItem` with given dimensions
    func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .estimated(Constant.headerHeight)
        )
        return .init(layoutSize: headerItemDimension, elementKind: UICollectionView.elementKindSectionHeader,  alignment: .top)
    }
    /// Generates `NSCollectionLayoutSection` with given group
    func generateSection(for group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.sectionInset,
            leading: Constant.sectionInset,
            bottom: Constant.sectionInset,
            trailing: Constant.sectionInset
        )
        
        section.boundarySupplementaryItems = [generateHeader()]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}
