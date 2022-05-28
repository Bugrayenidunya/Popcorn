//
//  AlbumAPI.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

// MARK: - AlbumFetchable
protocol AlbumFetchable {
    func retriveAlbum(request: AlbumRequestModel, completion: @escaping (Result<[Album], ApiError>) -> Void)
}

// MARK: - AlbumAPI
final class AlbumAPI: AlbumFetchable {
    
    // MARK: Properties
    private let networkManager: Networking
    
    // MARK: Init
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retriveAlbum(request: AlbumRequestModel, completion: @escaping (Result<[Album], ApiError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
