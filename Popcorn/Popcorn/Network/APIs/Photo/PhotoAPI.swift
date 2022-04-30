//
//  PhotoAPI.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

// MARK: - PhotoFetchable
protocol PhotoFetchable {
    func retrivePhoto(request: PhotoRequestModel, completion: @escaping (Result<[Photo], ApiError>) -> Void)
}

// MARK: - PhotoAPI
final class PhotoAPI: PhotoFetchable {
    
    // MARK: Properties
    private let networkManager: Networking
    
    // MARK: Init
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrivePhoto(request: PhotoRequestModel, completion: @escaping (Result<[Photo], ApiError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
