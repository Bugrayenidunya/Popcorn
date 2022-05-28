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
    func likePhoto(with viewModel: HomeCollectionViewCellViewModel)
    func disslikePhoto(with viewModel: HomeCollectionViewCellViewModel)
}

protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, userListDidLoad list: [User])
    func home(_ viewModel: HomeViewModelInput, albumListDidLoad list: [Album])
    func home(_ viewModel: HomeViewModelInput, photoDidLoad photo: [Photo])
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad section: [Section])
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
    
    weak var output: HomeViewModelOutput?
    
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
private extension HomeViewModel {
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
    
    func generateCellData() {
        userList.forEach { user in
            for album in albumList where album.id == user.id {
                for photo in photoList where photo.albumId == album.id {
                    let cellViewModel = HomeCollectionViewCellViewModel(
                        uuid: .init(),
                        userId: user.id ?? .zero,
                        albumId: album.id ?? .zero,
                        photoId: photo.id ?? .zero,
                        imageUrlStr: photo.thumbnailUrl ?? .empty,
                        name: user.name ?? .empty,
                        username: user.username ?? .empty,
                        phone: user.phone ?? .empty
                    )
                    
                    cells.append(cellViewModel)
                }
            }
        }
        
        groupPhotosByUserId(cell: cells)
    }
    
    func groupPhotosByUserId(cell: [HomeCollectionViewCellViewModel]) {
        let groupedPhotoes = Dictionary(grouping: cell, by: { $0.userId })
        var sections: [Section] = []
        
        groupedPhotoes.forEach { section, item in
            sections.append(.init(title: "User: \(section)", photos: item))
        }
        
        output?.home(self, sectionDidLoad: sections.sorted(by: { $0.hashValue < $1.hashValue }))
        self.photoList.removeAll()
    }
}
