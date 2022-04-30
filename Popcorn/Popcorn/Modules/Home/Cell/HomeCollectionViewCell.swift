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

protocol HomeCollectionViewCellViewDelegate: AnyObject {
    func collectionView(_ cell: HomeCollectionViewCell, likeButtonDidPressedWith viewModel: HomeCollectionViewCellViewModel)
}

// MARK: - HomeCollectionViewCell
final class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "HomeCollectionViewCell"
    
    private var viewModel: HomeCollectionViewCellViewModel?
    
    weak var delegate: HomeCollectionViewCellViewDelegate?
    
    // MARK: Views
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageView.downloaded(from: viewModel.imageUrlStr)
        setupLikeButton(with: viewModel.isFavorited)
    }
}

// MARK: - Helpers
private extension HomeCollectionViewCell {
    @objc
    func likeButtonPressed() {
        guard let viewModel = viewModel else { return }
        setupLikeButton(with: !viewModel.isFavorited)
        delegate?.collectionView(self, likeButtonDidPressedWith: viewModel)
    }
    
    func setupLikeButton(with isFavorited: Bool) {
        likeButton.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart"), for: .normal)
    }
    
    func setupView() {
        addSubview(imageView)
        addSubview(likeButton)
        
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
        
        likeButton.setConstarint(
            top: imageView.topAnchor,
            trailing: imageView.trailingAnchor,
            topConstraint: 8,
            trailingConstraint: 8,
            width: 32,
            height: 32)
    }
}
