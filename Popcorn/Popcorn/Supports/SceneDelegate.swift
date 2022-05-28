//
//  SceneDelegate.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 26.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let networkManager = NetworkManager(session: .shared)
        let userApi = UserAPI(networkManager: networkManager)
        let albumApi = AlbumAPI(networkManager: networkManager)
        let photoApi = PhotoAPI(networkManager: networkManager)
        let homeViewModel = HomeViewModel(userAPI: userApi, albumAPI: albumApi, photoAPI: photoApi)
        let homeController = HomeController(viewModel: homeViewModel)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: homeController)
        window?.makeKeyAndVisible()
    }
}

