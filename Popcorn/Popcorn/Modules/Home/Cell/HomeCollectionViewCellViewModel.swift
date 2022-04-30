//
//  HomeCollectionViewCellViewModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

struct HomeCollectionViewCellViewModel: UICollectionViewCellConfigurable, Codable {
    let uuid: UUID
    let userId: Int
    let albumId: Int
    let photoId: Int
    let imageUrlStr: String
    
    var isFavorited: Bool {
        do {
            let likedPhotos = try UserDefaultsManager.shared.getObject(
                forKey: Constant.UserDefaults.isLiked,
                castTo: [HomeCollectionViewCellViewModel].self
            )
            
            return likedPhotos.contains(where: { $0.photoId == photoId })
        } catch {
            return false
        }
    }
}
