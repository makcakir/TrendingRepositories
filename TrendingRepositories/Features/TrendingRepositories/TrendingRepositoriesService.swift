//
//  TrendingRepositoriesService.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

typealias LanguageColorsCompletion = (Result<[String: LanguageColor], Error>) -> Void
typealias TrendingRepositoriesCompletion = (Result<TrendingRepositoriesResponse, Error>) -> Void

protocol TrendingRepositoriesDataProtocol {
    
    func fetchLanguageColors(completion: @escaping LanguageColorsCompletion)
    
    func fetchTrendingRepositories(
        language: String, perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    )
}

final class TrendingRepositoriesService: TrendingRepositoriesDataProtocol {
    
    private enum Const {
        static let colorsUrl = "https://raw.githubusercontent.com/ozh/github-colors/master/colors.json"
        static let trendingUrl = "https://api.github.com/search/repositories?q=language%@+sort:stars&per_page=%d&page=%d"
    }
    
    func fetchLanguageColors(completion: @escaping LanguageColorsCompletion) {
        NetworkManager.shared.request(Const.colorsUrl) { result in
            completion(result)
        }
    }
    
    func fetchTrendingRepositories(
        language: String, perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    ) {
        let prefix = language.isEmpty ? "=" : ":"
        let lang = (language.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? "")
        let url = String(format: Const.trendingUrl, prefix + lang, perPage, page)
        NetworkManager.shared.request(url) { result in
            completion(result)
        }
    }
}
