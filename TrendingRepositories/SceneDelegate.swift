//
//  SceneDelegate.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let viewModel = TrendingRepositoriesViewModel()
        let viewController = TrendingRepositoriesViewController()
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
