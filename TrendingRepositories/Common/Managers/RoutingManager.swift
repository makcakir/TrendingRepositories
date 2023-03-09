//
//  RoutingManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 10.03.2023.
//

import UIKit

final class RoutingManager {
    
    static let shared = RoutingManager()
    
    func initializeWindow(windowScene: UIWindowScene) -> UIWindow {
        let viewModel = TrendingRepositoriesViewModel(dataProtocol: TrendingRepositoriesService())
        let viewController = TrendingRepositoriesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return window
    }
}
