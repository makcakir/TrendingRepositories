//
//  TrendingRepositoriesViewModel.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

final class TrendingRepositoriesViewModel: ViewModel<TrendingRepositoriesDependency> {

    enum PresentationType: Equatable {
        case data(item: TrendingRepositoryPresentation)
        case loading
    }

    enum Change: Equatable {
        case error
        case hideSearch
        case items(items: [PresentationType], resultMessage: String)
        case loading(items: [PresentationType])
        case paginationEnded
        case selected(item: PresentationType, index: Int)
        case showSearch(filters: [String], selectedIndex: Int)
    }

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    private let router: TrendingRepositoriesRoutingProtocol
    private var colors: [String: LanguageColor] = [:]
    private var expandStates: [Bool] = []
    private var repositories: [Repository] = []
    private var isFetching = false
    private var totalCount = 0
    private var selectedFilterIndex: Int = 0
    private var selectedLanguage: String? {
        guard  selectedFilterIndex > 0, selectedFilterIndex < Const.filters.count else {
            return nil
        }
        return Const.filters[selectedFilterIndex]
    }

    var changeHandler: ((Change) -> Void)?

    init(
        dependency: TrendingRepositoriesDependency, router: TrendingRepositoriesRoutingProtocol
    ) {
        self.router = router
        super.init(dependency: dependency)
        fetchColors()
    }

    func fetchRepositories() {
        expandStates = []
        repositories = []
        let loadingItems = [PresentationType](repeating: .loading, count: dependency.pageItemCount)
        changeHandler?(.loading(items: loadingItems))
        fetchRepositories(page: 1)
    }

    func fetchNextPage() {
        guard !isFetching, repositories.count < totalCount else {
            return
        }
        let currentPage = repositories.count / dependency.pageItemCount
        fetchRepositories(page: currentPage + 1)
    }

    func selectRepositoryAt(_ index: Int) {
        guard index < expandStates.count else {
            return
        }
        expandStates[index].toggle()
        let item = createPresentationFrom(
            repositories[index], index: index, isExpanded: expandStates[index]
        )
        changeHandler?(.selected(item: PresentationType.data(item: item), index: index))
    }

    func openRepositoryDetailAt(_ index: Int) {
        guard index < repositories.count else {
            return
        }
        router.routeToUrl(repositories[index].htmlUrl)
    }

    func openHomepageAt(_ index: Int) {
        guard index < repositories.count,
            let homepageUrl = repositories[index].homepage else {
            return
        }
        router.routeToUrl(homepageUrl)
    }

    func selectFilterAt(_ index: Int) {
        guard index != selectedFilterIndex else {
            return
        }
        selectedFilterIndex = index
        fetchRepositories()
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewModel {

    enum Const {
        static let filters = [
            R.string.localizable.all(), "Assembly", "C", "C#", "C++", "CSS", "Dart", "Dockerfile", "Go", "HTML", "Java",
            "JavaScript", "Kotlin", "Lua", "Makefile", "Markdown", "Objective-C", "Perl", "PHP", "Python", "Ruby",
            "Rust", "Scala", "Shell", "Swift", "TypeScript", "Vue"
        ]
    }

    func fetchColors() {
        dependency.dispatchGroup.enter()
        dependency.network.request(
            endPoint: .colors
        ) { [weak self] (result: Result<[String: LanguageColor], Error>) in
            guard let self else {
                return
            }
            self.dependency.dispatchGroup.leave()
            switch result {
            case .success(let colors):
                self.colors = colors
            case .failure:
                // Left blank intentionally!
                break
            }
        }
    }

    func fetchRepositories(page: Int) {
        dependency.dispatchGroup.enter()
        isFetching = true
        let endPoint = Endpoint.repositories(language: selectedLanguage, perPage: dependency.pageItemCount, page: page)
        var res: Result<TrendingRepositoriesResponse, Error>?
        dependency.network.request(
            endPoint: endPoint
        ) { [weak self] (result: Result<TrendingRepositoriesResponse, Error>) in
            guard let self else {
                return
            }
            self.dependency.dispatchGroup.leave()
            res = result
        }

        dependency.dispatchGroup.notify {
            guard let result = res else {
                return
            }
            switch result {
            case .success(let response):
                self.isFetching = false
                self.totalCount = response.totalCount
                let dataItems = response.items.map {
                    let item = self.createPresentationFrom(
                        $0, index: self.repositories.count, isExpanded: false
                    )
                    self.repositories.append($0)
                    self.expandStates.append(item.isExpanded)
                    return PresentationType.data(item: item)
                }
                // swiftlint:disable:next legacy_objc_type
                let formattedCount = self.numberFormatter.string(from: response.totalCount as NSNumber)
                let resultMessage = R.string.localizable.resultMessage(formattedCount ?? "")
                self.changeHandler?(.showSearch(filters: Const.filters, selectedIndex: self.selectedFilterIndex))
                self.changeHandler?(.items(items: dataItems, resultMessage: resultMessage))

                if self.repositories.count >= self.totalCount {
                    self.changeHandler?(.paginationEnded)
                }
            case .failure:
                self.changeHandler?(.hideSearch)
                self.changeHandler?(.error)
            }
        }
    }

    func createPresentationFrom(
        _ repository: Repository, index: Int, isExpanded: Bool
    ) -> TrendingRepositoryPresentation {
        let owner = OwnerPresentation(
            imageUrl: repository.owner.avatarUrl, name: repository.owner.login
        )
        var languagePresentation: LanguagePresentation?
        if let language = repository.language {
            languagePresentation = LanguagePresentation(
                name: language, colorHex: colors[language]?.color ?? "#CCCCCC"
            )
        }
        // swiftlint:disable:next legacy_objc_type
        let count = numberFormatter.string(from: repository.starCount as NSNumber)
        let index = "#" + String(index + 1)
        return TrendingRepositoryPresentation(
            index: index, owner: owner, title: repository.name, description: repository.description,
            language: languagePresentation, starCount: count ?? "",
            shouldDisplayInfoButton: repository.homepage != nil, isExpanded: isExpanded
        )
    }
}
