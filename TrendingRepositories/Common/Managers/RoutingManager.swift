//
//  RoutingManager.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 10.03.2023.
//

import SafariServices
import UIKit

final class RoutingManager {
    
    private enum Const {
        static let pageItemCount = 50
    }
    
    private var rootViewController: UINavigationController?
    
    static let shared = RoutingManager()
    
    func initializeWindow(windowScene: UIWindowScene) -> UIWindow {
        let dependency = TrendingRepositoriesDependency(
            pageItemCount: Const.pageItemCount, dispatchGroup: DispatchGroup(), network: NetworkManager.shared
        )
        let viewModel = TrendingRepositoriesViewModel(
            dependency: dependency, router: TrendingRepositoriesRouter()
        )
        let viewController = TrendingRepositoriesViewController(viewModel: viewModel)
        rootViewController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        return window
    }
    
    func openWebURL(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        rootViewController?.present(safariViewController, animated: true)
    }
}
