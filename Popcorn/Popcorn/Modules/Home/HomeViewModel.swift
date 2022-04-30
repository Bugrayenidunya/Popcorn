//
//  HomeViewModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 28.04.2022.
//

import Foundation

// MARK: - Protocols
protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    
    func viewDidLoad()
    func retriveUserList()
    func retrieveAlbums(for user: User)
    func retrievePhotos(for album: Album)
}

protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, userListDidLoad list: [User])
    func home(_ viewModel: HomeViewModelInput, albumListDidLoad list: [Album])
    func home(_ viewModel: HomeViewModelInput, photoDidLoad photo: [Photo])
    func home(_ viewModel: HomeViewModelInput, cellDidLoad cell: [HomeCollectionViewCellViewModel])
}

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput {
    
    
    // MARK: Properties
    private var userList: [User] = []
    private var albumList: [Album] = []
    private var photoList: [Photo] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    
    private let userAPI: UserFetchable
    private let albumAPI: AlbumFetchable
    private let photoAPI: PhotoFetchable
    
    var output: HomeViewModelOutput?
    
    // MARK: Init
    init(userAPI: UserFetchable,
         albumAPI: AlbumFetchable,
         photoAPI: PhotoFetchable) {
        self.userAPI = userAPI
        self.albumAPI = albumAPI
        self.photoAPI = photoAPI
    }
    
    // MARK: Functions
    func viewDidLoad() {
        retriveUserList()
    }
    
    func retriveUserList() {
        userAPI.retriveUser(request: .init()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userList):
                self.userList.append(contentsOf: userList)
                self.output?.home(self, userListDidLoad: userList)
                
            case .failure(let error):
                // TODO: Implement
                print(error.localizedDescription)
            }
        }
    }
    
    func retrieveAlbums(for user: User) {
        guard let userId = user.id else { return }
        
        albumAPI.retriveAlbum(request: .init(userId: userId)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let albumList):
                self.albumList.append(contentsOf: albumList)
                self.output?.home(self, albumListDidLoad: albumList)
                print(albumList)
                
            case .failure(let error):
                // TODO: Implement
                print(error.localizedDescription)
            }
        }
    }
    
    func retrievePhotos(for album: Album) {
        guard let albumId = album.id else { return }
        
        photoAPI.retrivePhoto(request: .init(albumId: Int(albumId) )) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photo):
                self.photoList.append(contentsOf: photo)
                self.output?.home(self, photoDidLoad: photo)
                self.generateCellData()
                
            case .failure(let error):
                // TODO: Implement
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func generateCellData() {
        userList.forEach { user in
            for album in albumList where album.id == user.id {
                for photo in photoList where photo.albumId == album.id {
                    let cellViewModel = HomeCollectionViewCellViewModel(
                        uuid: .init(),
                        userId: user.id ?? .zero,
                        albumId: album.id ?? .zero,
                        photoId: photo.id ?? .zero,
                        imageUrlStr: photo.thumbnailUrl ?? ""
                    )
                    
                    cells.append(cellViewModel)
                }
            }
        }
        
        output?.home(self, cellDidLoad: cells)
        self.photoList.removeAll()
    }
}
