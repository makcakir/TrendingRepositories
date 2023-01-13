//
//  TrendingRepositoriesResponse.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

struct Owner: Decodable {
    let avatarUrl: String
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}

struct Repository: Decodable {
    let description: String
    let language: String?
    let name: String
    let owner: Owner
    let starCount: Int
    
    enum CodingKeys: String, CodingKey {
        case description
        case language
        case name
        case owner
        case starCount = "stargazers_count"
    }
}

struct TrendingRepositoriesResponse: Decodable {
    let items: [Repository]
}
