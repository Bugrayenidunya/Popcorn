//
//  DetailViewModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 30.04.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailViewModelInput {
    func likePhoto(with viewModel: HomeCollectionViewCellViewModel)
    func disslikePhoto(with viewModel: HomeCollectionViewCellViewModel)
}

// MARK: - DetailViewModelInput
final class DetailViewModel: DetailViewModelInput {
    
    // MARK: Functions
    func likePhoto(with viewModel: HomeCollectionViewCellViewModel) {
        do {
            if !getLikedPhotos().isEmpty {
                var likedPhotos = getLikedPhotos()
                
                if !likedPhotos.contains(where: { $0.photoId == viewModel.photoId }) {
                    likedPhotos.append(viewModel)
                }
                
                try UserDefaultsManager.shared.setObject(likedPhotos, forKey: Constant.UserDefaults.isLiked)
            } else {
                try UserDefaultsManager.shared.setObject([viewModel], forKey: Constant.UserDefaults.isLiked)
            }
            
        } catch {
        }
    }
    
    func disslikePhoto(with viewModel: HomeCollectionViewCellViewModel) {
        do {
            var likedPhotos = getLikedPhotos()
            likedPhotos.removeAll(where: { $0.photoId == viewModel.photoId })
            
            try UserDefaultsManager.shared.setObject(likedPhotos, forKey: Constant.UserDefaults.isLiked)
        } catch {
        }
    }
}

// MARK: - Helpers
private extension DetailViewModel {
    func getLikedPhotos() -> [HomeCollectionViewCellViewModel] {
        do {
            let likedPhotos = try UserDefaultsManager.shared.getObject(
                forKey: Constant.UserDefaults.isLiked,
                castTo: [HomeCollectionViewCellViewModel].self
            )
            
            return likedPhotos
        } catch {
            return []
        }
    }
}
