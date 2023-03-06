//
//  TrendingRepositoryPresentation.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

struct OwnerPresentation: Equatable {
    let imageUrl: String
    let name: String
}

struct LanguagePresentation: Equatable {
    let name: String
    let colorHex: String
}

struct TrendingRepositoryPresentation: Equatable {
    let owner: OwnerPresentation
    let title: String
    let description: String
    let language: LanguagePresentation?
    let starCount: String
    let isExpanded: Bool
}
