//
//  HomeCollectionViewCellViewModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

struct HomeCollectionViewCellViewModel: UICollectionViewCellConfigurable {
    let uuid: UUID
    let userId: Int
    let albumId: Int
    let photoId: Int
    let imageUrlStr: String
}
