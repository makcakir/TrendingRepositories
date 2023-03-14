//
//  TrendingRepositoriesService.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

typealias TrendingRepositoriesCompletion = (Result<TrendingRepositoriesResponse, Error>) -> Void

protocol TrendingRepositoriesDataProtocol {
    
    func fetchTrendingRepositories(
        perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    )
}

final class TrendingRepositoriesService: TrendingRepositoriesDataProtocol {
    
    private enum Const {
        static let trendingUrl = "https://api.github.com/search/repositories?q=language=+sort:stars&per_page=%d&page=%d"
    }
    
    func fetchTrendingRepositories(
        perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    ) {
        let url = String(format: Const.trendingUrl, perPage, page)
        NetworkManager.shared.request(url) { (result: Result<TrendingRepositoriesResponse, Error>) in
            completion(result)
        }
    }
}
