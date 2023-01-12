//
//  TrendingRepositoryPresentation.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

struct OwnerPresentation {
    let imageUrl: String
    let name: String
}

struct LanguagePresentation {
    let name: String
    let colorHex: String
}

class TrendingRepositoryPresentation {
    
    let owner: OwnerPresentation
    let title: String
    let description: String
    let language: LanguagePresentation?
    let starCount: String
    var isExpanded: Bool
    
    init(
        owner: OwnerPresentation, title: String, description: String,
        language: LanguagePresentation?, starCount: String, isExpanded: Bool
    ) {
        self.owner = owner
        self.title = title
        self.description = description
        self.language = language
        self.starCount = starCount
        self.isExpanded = isExpanded
    }
}
