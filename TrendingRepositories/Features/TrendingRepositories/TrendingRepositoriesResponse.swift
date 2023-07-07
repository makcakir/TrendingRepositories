//
//  TrendingRepositoriesResponse.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

@propertyWrapper
struct FailableDecodable<T: Decodable>: Decodable {
    var wrappedValue: T?

    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        wrappedValue = try? decoder.singleValueContainer().decode(T.self)
    }
}

struct Owner: Decodable {
    let avatarUrl: URL
    let login: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}

struct Repository: Decodable {
    let description: String?
    @FailableDecodable private(set) var homepage: URL?
    let htmlUrl: URL
    let language: String?
    let name: String
    let owner: Owner
    let starCount: Int

    enum CodingKeys: String, CodingKey {
        case description
        case homepage
        case htmlUrl = "html_url"
        case language
        case name
        case owner
        case starCount = "stargazers_count"
    }
}

struct TrendingRepositoriesResponse: Decodable {
    let items: [Repository]
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}
