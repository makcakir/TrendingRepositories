//
//  Endpoint.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 21.03.2023.
//

import Foundation

enum Endpoint {
    case colors
    case repositories(language: String?, perPage: Int, page: Int)
}

// MARK: - Computed properties

extension Endpoint {

    enum Method: String {
        case get
        case post
    }

    var baseURL: String {
        switch self {
        case .colors:
            return "https://raw.githubusercontent.com/"
        case .repositories:
            return "https://api.github.com/"
        }
    }

    var path: String {
        switch self {
        case .colors:
            return "ozh/github-colors/master/colors.json"
        case .repositories:
            return "search/repositories"
        }
    }

    var method: Method {
        switch self {
        case .colors:
            return .get
        case .repositories:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .colors:
            return nil
        case let .repositories(language, perPage, page):
            var languageQuery = "stars:>1"
            if let lang = language {
                languageQuery += " language:" + lang
            }
            return ["q": languageQuery, "per_page": perPage, "page": page, "sort": "stars" ]
        }
    }
}
