//
//  TrendingRepositoriesDependency.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 12.04.2023.
//

import Foundation

final class TrendingRepositoriesDependency: NetworkDependency {
    
    let pageItemCount: Int
    let dispatchGroup: DispatchGroupProtocol
    
    init(pageItemCount: Int, dispatchGroup: DispatchGroupProtocol, network: NetworkProtocol) {
        self.pageItemCount = pageItemCount
        self.dispatchGroup = dispatchGroup
        super.init(network: network)
    }
}
