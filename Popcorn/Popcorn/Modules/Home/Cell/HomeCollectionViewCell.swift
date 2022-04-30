//
//  HomeCollectionViewCell.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import UIKit

// MARK: UICollectionViewCellConfigurable
protocol UICollectionViewCellConfigurable: Hashable {
    
}

// MARK: - HomeCollectionViewCell
final class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "HomeCollectionViewCell"
    
    // MARK: Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        imageView.downloaded(from: viewModel.imageUrlStr)
    }
}

// MARK: - Helpers
private extension HomeCollectionViewCell {
    func setupView() {
        addSubview(imageView)
        
        imageView.setConstarint(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            topConstraint: 0,
            leadingConstraint: 0,
            bottomConstraint: 0,
            trailingConstraint: 0
        )
    }
}
