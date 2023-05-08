//
//  TrendingRepositoriesFakeService.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 06.03.2023.
//

import Foundation
@testable import TrendingRepositories

final class TrendingRepositoriesFakeService {
    
    var isSuccess = false
}

// MARK: - Helpers

private extension TrendingRepositoriesFakeService {
    
    enum FakeError: Error {
        case invalidResponse
    }
    
    func prepareColorsResponse() -> Result<[String: LanguageColor], Error> {
        let languageColor1 = LanguageColor(
            color: "#F34B7D", url: URL(unsafeString: "https://github.com/trending?l=C++")
        )
        let languageColor2 = LanguageColor(
            color: "#B07219", url: URL(unsafeString: "https://github.com/trending?l=Java")
        )
        return .success(["C++": languageColor1, "Java": languageColor2])
    }
    
    func prepareItems() -> [Repository] {
        let owner1 = Owner(
            avatarUrl: URL(string: "https://avatars.apple.com")!, login: "apple"
        )
        let repository1 = Repository(
            description: "The Swift Programming Language", homepage: URL(string: "https://swift.org"),
            htmlUrl: URL(string: "https://github.com/apple/swift")!, language: "C++", name: "swift",
            owner: owner1, starCount: 61983
        )
        let owner2 = Owner(
            avatarUrl: URL(string: "https://avatars.akullpp.com")!, login: "akullpp"
        )
        let repository2 = Repository(
            description: "A curated list of awesome frameworks", homepage: nil,
            htmlUrl: URL(string: "https://github.com/akullpp/awesome-java")!, language: nil,
            name: "awesome-java", owner: owner2, starCount: 35638
        )
        let owner3 = Owner(
            avatarUrl: URL(string: "https://avatars.bazelbuild.com")!, login: "bazelbuild"
        )
        let repository3 = Repository(
            description: "a fast, scalable, multi-language and extensible build system",
            homepage: URL(string: "https://bazel.build"),
            htmlUrl: URL(string: "https://github.com/bazelbuild/bazel")!, language: "Java",
            name: "bazel", owner: owner3, starCount: 20432
        )
        return [repository1, repository2, repository3]
    }
    
    func prepareRepositoriesResponse(
        language: String?, perPage: Int, page: Int
    ) -> Result<TrendingRepositoriesResponse, Error> {
        let items = prepareItems()
        let filteredItems: [Repository]
        if language?.isEmpty ?? true {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.language == language }
        }
        let currentCount = perPage * (page - 1)
        let remainingCount = filteredItems.count - currentCount
        guard isSuccess, currentCount <= filteredItems.count else {
            return .failure(FakeError.invalidResponse)
        }
        let lastIndex = min(remainingCount, perPage)
        let response = TrendingRepositoriesResponse(
            items: Array(filteredItems[currentCount..<currentCount + lastIndex]), totalCount: filteredItems.count
        )
        return .success(response)
    }
}

// MARK: - NetworkProtocol

extension TrendingRepositoriesFakeService: NetworkProtocol {
    
    func request<T: Decodable>(
        endPoint: TrendingRepositories.Endpoint, completion: @escaping (Result<T, Error>) -> Void
    ) {
        switch endPoint {
        case .colors:
            completion(prepareColorsResponse() as! Result<T, Error>)
        case .repositories(let language, let perPage, let page):
            completion(prepareRepositoriesResponse(language: language, perPage: perPage, page: page) as! Result<T, Error>)
        }
    }
}
