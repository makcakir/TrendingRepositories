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
    
    private var isSuccess = false
    private var items: [Repository] = []
    private var result: Result<TrendingRepositoriesResponse, Error> = .failure(FakeError.invalidResponse)
    
    func setupSuccessData() {
        isSuccess = true
        let owner1 = Owner(
            avatarUrl: URL(string: "https://avatars.apple.com")!, login: "apple"
        )
        let repository1 = Repository(
            description: "The Swift Programming Language", homepage: "https://swift.org",
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
            homepage: "https://bazel.build",
            htmlUrl: URL(string: "https://github.com/bazelbuild/bazel")!, language: "Java",
            name: "bazel", owner: owner3, starCount: 20432
        )
        items = [repository1, repository2, repository3]
    }
}

// MARK: - TrendingRepositoriesDataProtocol

extension TrendingRepositoriesFakeService: TrendingRepositoriesDataProtocol {
    
    func fetchLanguageColors(completion: @escaping LanguageColorsCompletion) {
        let languageColor1 = LanguageColor(
            color: "#F34B7D", url: URL(unsafeString: "https://github.com/trending?l=C++")
        )
        let languageColor2 = LanguageColor(
            color: "#B07219", url: URL(unsafeString: "https://github.com/trending?l=Java")
        )
        completion(.success(["C++": languageColor1, "Java": languageColor2]))
    }
    
    func fetchTrendingRepositories(
        language: String, perPage: Int, page: Int, completion: @escaping TrendingRepositoriesCompletion
    ) {
        let filteredItems: [Repository]
        if !language.isEmpty {
            filteredItems = items.filter { $0.language == language }
        } else {
            filteredItems = items
        }
        let currentCount = perPage * (page - 1)
        let remainingCount = filteredItems.count - currentCount
        guard isSuccess, currentCount <= filteredItems.count else {
            completion(result)
            return
        }
        let lastIndex = min(remainingCount, perPage)
        let response = TrendingRepositoriesResponse(
            items: Array(filteredItems[currentCount..<currentCount + lastIndex]), totalCount: filteredItems.count
        )
        completion(.success(response))
    }
}
