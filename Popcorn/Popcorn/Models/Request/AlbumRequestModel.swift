//
//  AlbumRequestModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

final class AlbumRequestModel: RequestModel {
    
    private let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    override var path: String {
        Constant.API.albums
    }
    
    override var method: RequestMethod {
        .get
    }
    
    override var parameters: [String : Any?] {
        [
            "userId": String(self.userId)
        ]
    }
}
