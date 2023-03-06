//
//  TrendingRepositoriesFakeService.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 6.03.2023.
//

import Foundation
@testable import TrendingRepositories

final class TrendingRepositoriesFakeService {
    
    enum FakeError: Error {
        case invalidResponse
    }
    
    private var result: Result<TrendingRepositoriesResponse, Error>?
    
    func setupErrorData() {
        result = .failure(FakeError.invalidResponse)
    }
    
    func setupSuccessData() {
        let owner1 = Owner(
            avatarUrl: "https://avatars.apple.com", login: "apple"
        )
        let repository1 = Repository(
            description: "The Swift Programming Language", language: "C++", name: "swift",
            owner: owner1, starCount: 61983
        )
        let owner2 = Owner(
            avatarUrl: "https://avatars.akullpp.com", login: "akullpp"
        )
        let repository2 = Repository(
            description: "A curated list of awesome frameworks",
            language: nil, name: "awesome-java", owner: owner2, starCount: 35638
        )
        let response = TrendingRepositoriesResponse(items: [repository1, repository2])
        result = .success(response)
    }
}

// MARK: - TrendingRepositoriesDataProtocol

extension TrendingRepositoriesFakeService: TrendingRepositoriesDataProtocol {
    
    func fetchTrendingRepositories(completion: @escaping TrendingRepositories.TrendingRepositoriesCompletion) {
        guard let result = result else {
            return
        }
        completion(result)
    }
}
