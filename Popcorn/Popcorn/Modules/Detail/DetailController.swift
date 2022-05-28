//
//  DetailController.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 30.04.2022.
//

import UIKit

// MARK: - DetailControllerModuleOutput
protocol DetailControllerModuleOutput: AnyObject {
    func photoDidLike(with viewModel: HomeCollectionViewCellViewModel)
}

// MARK: - DetailController
final class DetailController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DetailViewModel
    private let cellViewModel: HomeCollectionViewCellViewModel
    
    weak var moduleOutput: DetailControllerModuleOutput?

    // MARK: Views
    private var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var surnameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var phoneLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLikeButton(with: cellViewModel.isLiked)
    }
    
    init(viewModel: DetailViewModel, cellViewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        self.cellViewModel = cellViewModel
        
        super.init(nibName: nil, bundle: .main)
        
        setupNavBar(with: "User: \(cellViewModel.userId)")
        configure(with: cellViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension DetailController {
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        nameLabel.text = "Name: \(viewModel.name)"
        surnameLabel.text = "Username: \(viewModel.username)"
        phoneLabel.text = "Phone: \(viewModel.phone)"
    }
    
    func setupNavBar(with title: String) {
        navigationItem.title = title
    }
    
    @objc
    func likeButtonPressed() {
        moduleOutput?.photoDidLike(with: cellViewModel)
        setupLikeButton(with: !cellViewModel.isLiked)
        cellViewModel.isLiked ?
        self.viewModel.disslikePhoto(with: cellViewModel) :
        self.viewModel.likePhoto(with: cellViewModel)
    }
    
    func setupLikeButton(with isFavorited: Bool) {
        likeButton.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart"), for: .normal)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(phoneLabel)
        view.addSubview(likeButton)
        
        nameLabel.setConstarint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            topConstraint: 48,
            leadingConstraint: 16
        )
        
        surnameLabel.setConstarint(
            top: nameLabel.bottomAnchor,
            leading: view.leadingAnchor,
            topConstraint: 10,
            leadingConstraint: 16
        )
        
        phoneLabel.setConstarint(
            top: surnameLabel.bottomAnchor,
            leading: view.leadingAnchor,
            topConstraint: 10,
            leadingConstraint: 16
        )
        
        likeButton.setConstarint(
            top: phoneLabel.bottomAnchor,
            topConstraint: 32,
            centerX: view.centerXAnchor,
            width: 72,
            height: 72
        )
    }
}
