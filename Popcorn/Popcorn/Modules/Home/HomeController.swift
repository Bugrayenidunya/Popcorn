//
//  HomeController.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 26.04.2022.
//

import UIKit

// MARK: - Enums
enum Section: Int, Hashable, CaseIterable {
    case main
}

// MARK: - HomeController
final class HomeController: UIViewController {
    
    // MARK: Properties
    private var viewModel: HomeViewModelInput
    private var dataSource: UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>!
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
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupView()
        viewModel.viewDidLoad()
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
        // TODO: Implement
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

    /// Generates `UICollectionViewCompositionalLayout` with given items, group, header and section
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let (smallItem, mediumItem, largeItem) = generateLayoutItems()
        
        // Inner Group
        let innerGroupDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.quarter),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupDimension, subitems: [smallItem, mediumItem])
        
        // Outer Group
        let outerGroupDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.quarter),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupDimension, subitems: [largeItem, innerGroup, innerGroup])
        
        return .init(section: generateSection(for: outerGroup))
    }
    /// Generates `NSCollectionLayoutItem` with given dimensions
    func generateLayoutItems() -> (small: NSCollectionLayoutItem, medium: NSCollectionLayoutItem, large: NSCollectionLayoutItem) {
        // Small Item
        let smallItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.quarter),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemDimension)
        
        // Medium Item
        let mediumItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.half),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let mediumItem = NSCollectionLayoutItem(layoutSize: mediumItemDimension)
        
        // Large Item
        let largeItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .fractionalHeight(Constant.full)
        )
        
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemDimension)
        
        return (smallItem, mediumItem, largeItem)
    }
    /// Generates `NSCollectionLayoutBoundarySupplementaryItem` with given dimensions
    func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemDimension = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.full),
            heightDimension: .estimated(Constant.headerHeight)
        )
        return .init(layoutSize: headerItemDimension, elementKind: Constant.headerKind,  alignment: .top)
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
        
        return section
    }
}