//
//  TrendingRepositoriesViewModel.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

class TrendingRepositoriesViewModel {
    
    enum Change {
        case error
        case items(items: [TrendingRepositoryPresentation])
        case loading
    }
    
    var changeHandler: ((Change) -> Void)?
    
    func fetchRepositories(forceError: Bool = false) {
        changeHandler?(.loading)
        if forceError {
            changeHandler?(.error)
        } else {
            let items = prepareMockItems()
            changeHandler?(.items(items: items))
        }
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewModel {
    
    func prepareMockItems() -> [TrendingRepositoryPresentation] {
        var items: [TrendingRepositoryPresentation] = []
        for i in 1...15 {
            let presentation = TrendingRepositoryPresentation(
                ownerImageUrl: "", ownerName: "Owner \(i)", title: "Title \(i)",
                description: "Description", language: "Language", starCount: i
            )
            items.append(presentation)
        }
        return items
    }
}
