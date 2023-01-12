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
            let description: String
            if i % 2 == 0 {
                description = "Description"
            } else {
                description = "Long description long description long description long description."
            }
            let owner = OwnerPresentation(
                imageUrl: "", name:  "Owner \(i)"
            )
            let language = LanguagePresentation(
                name: "Language", colorHex: "#00ADD8"
            )
            let presentation = TrendingRepositoryPresentation(
                owner: owner, title: "Title \(i)", description: description, language: language,
                starCount: String(i), isExpanded: false
            )
            items.append(presentation)
        }
        return items
    }
}
