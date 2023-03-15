//
//  TrendingRepositoriesRouter.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 15.03.2023.
//

import Foundation
@testable import TrendingRepositories

final class TrendingRepositoriesFakeRouter {
    
    private(set) var url: URL?
}

// MARK: - TrendingRepositoriesRoutingProtocol

extension TrendingRepositoriesFakeRouter: TrendingRepositoriesRoutingProtocol {
    
    func routeToUrl(_ url: URL) {
        self.url = url
    }
}
