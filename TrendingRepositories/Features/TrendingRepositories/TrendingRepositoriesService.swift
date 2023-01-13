//
//  TrendingRepositoriesService.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 13.01.2023.
//

import Foundation

typealias TrendingRepositoriesCompletion = (Result<TrendingRepositoriesResponse, Error>) -> Void

protocol TrendingRepositoriesDataProtocol {
    
    func fetchTrendingRepositories(completion: @escaping TrendingRepositoriesCompletion)
}

class TrendingRepositoriesService: TrendingRepositoriesDataProtocol {
    
    private enum Const {
        static let trendingUrl = "https://api.github.com/search/repositories?q=language=+sort:stars"
    }
    
    func fetchTrendingRepositories(completion: @escaping TrendingRepositoriesCompletion) {
        let url = URL(string: Const.trendingUrl)!
        NetworkManager.shared.request(fromURL: url) { (result: Result<TrendingRepositoriesResponse, Error>) in
            completion(result)
        }
    }
}

class TrendingRepositoriesSuccessMockService: TrendingRepositoriesDataProtocol {
    
    func fetchTrendingRepositories(completion: @escaping TrendingRepositoriesCompletion) {
        let response = TrendingRepositoriesResponse(items: [])
        completion(.success(response))
    }
}

class TrendingRepositoriesErrorMockService: TrendingRepositoriesDataProtocol {
    
    func fetchTrendingRepositories(completion: @escaping TrendingRepositoriesCompletion) {
        completion(.failure(NetworkManager.NetworkError.invalidResponse))
    }
}
