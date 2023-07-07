//
//  TrendingRepositoriesRouter.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 15.03.2023.
//

import Foundation

protocol TrendingRepositoriesRoutingProtocol {

    func routeToUrl(_ url: URL)
}

final class TrendingRepositoriesRouter: TrendingRepositoriesRoutingProtocol {

    func routeToUrl(_ url: URL) {
        RoutingManager.shared.openWebURL(url)
    }
}
