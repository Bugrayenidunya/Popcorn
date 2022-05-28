//
//  PhotoRequestModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

final class PhotoRequestModel: RequestModel {
    
    private let albumId: Int
    
    init(albumId: Int) {
        self.albumId = albumId
    }
    
    override var path: String {
        Constant.API.photos
    }
    
    override var method: RequestMethod {
        .get
    }
    
    override var parameters: [String : Any?] {
        [
            "albumId": String(self.albumId)
        ]
    }
}
