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

extension OwnerPresentation: Equatable {
    
    static func == (lhs: OwnerPresentation, rhs: OwnerPresentation) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.name == rhs.name
    }
}

struct LanguagePresentation {
    let name: String
    let colorHex: String
}

extension LanguagePresentation: Equatable {
    
    static func == (lhs: LanguagePresentation, rhs: LanguagePresentation) -> Bool {
        return lhs.name == rhs.name && lhs.colorHex == rhs.colorHex
    }
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

extension TrendingRepositoryPresentation: Equatable {
    
    static func == (lhs: TrendingRepositoryPresentation, rhs: TrendingRepositoryPresentation) -> Bool {
        return lhs.owner == rhs.owner && lhs.title == rhs.title &&
        lhs.description == rhs.description && lhs.language == rhs.language &&
        lhs.starCount == rhs.starCount && lhs.isExpanded == rhs.isExpanded
    }
}
