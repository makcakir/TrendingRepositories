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
        language: String?, perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    )
}

final class TrendingRepositoriesService: TrendingRepositoriesDataProtocol {
    
    func fetchLanguageColors(completion: @escaping LanguageColorsCompletion) {
        NetworkManager.shared.request(endPoint: .colors) { result in
            completion(result)
        }
    }
    
    func fetchTrendingRepositories(
        language: String?, perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    ) {
        NetworkManager.shared.request(endPoint: .repositories(language: language, perPage: perPage, page: page)) { result in
            completion(result)
        }
    }
}
