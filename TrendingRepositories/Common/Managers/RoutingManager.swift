//
//  RoutingManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 10.03.2023.
//

import UIKit

final class RoutingManager {
    
    private enum Const {
        static let pageItemCount = 20
    }
    
    static let shared = RoutingManager()
    
    func initializeWindow(windowScene: UIWindowScene) -> UIWindow {
        let viewModel = TrendingRepositoriesViewModel(
            dataProtocol: TrendingRepositoriesService(), pageItemCount: Const.pageItemCount
        )
        let viewController = TrendingRepositoriesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return window
    }
}
