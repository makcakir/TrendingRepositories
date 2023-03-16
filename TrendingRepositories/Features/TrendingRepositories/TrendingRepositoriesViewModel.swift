//
//  TrendingRepositoriesViewModel.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

final class TrendingRepositoriesViewModel {
    
    enum PresentationType: Equatable {
        case data(item: TrendingRepositoryPresentation)
        case loading
    }
    
    enum Change: Equatable {
        case error
        case hideSearch
        case items(items: [PresentationType])
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
    
    private let pageItemCount: Int
    private let dataProtocol: TrendingRepositoriesDataProtocol
    private let router: TrendingRepositoriesRoutingProtocol
    private var expandStates: [Bool] = []
    private var repositories: [Repository] = []
    private var isFetching = false
    private var totalCount = 0
    private var selectedFilterIndex: Int = 0
    private var selectedLanguage: String {
        guard  selectedFilterIndex > 0, selectedFilterIndex < Const.filters.count else {
            return ""
        }
        return Const.filters[selectedFilterIndex]
    }
    
    var changeHandler: ((Change) -> Void)?
    
    init(
        pageItemCount: Int, dataProtocol: TrendingRepositoriesDataProtocol,
        router: TrendingRepositoriesRoutingProtocol
    ) {
        self.pageItemCount = pageItemCount
        self.dataProtocol = dataProtocol
        self.router = router
    }
    
    func fetchRepositories() {
        expandStates = []
        repositories = []
        let loadingItems = [PresentationType](repeating: .loading, count: pageItemCount)
        changeHandler?(.loading(items: loadingItems))
        fetchRepositories(page: 1)
    }
    
    func fetchNextPage() {
        guard !isFetching, repositories.count < totalCount else {
            return
        }
        let currentPage = repositories.count / pageItemCount
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
              let homepageUrl = URL(string: repositories[index].homepage ?? "") else {
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
        static let colorsDictionary = [
            "Agda": "#315665", "Assembly": "#6E4C13", "Ballerina": "#FF5000", "Bicep": "#519ABA",
            "C": "#555555", "C#": "#178600", "C++": "#F34B7D", "Chapel": "#8DC63F", "Clojure": "#DB5855",
            "CMake": "#DA3434", "CoffeeScript": "#244776", "Common Lisp": "#3FB68B", "Coq": "#d0b68c",
            "Crystal": "#000100", "CSS": "#563D7C", "D": "#BA595E", "Dart": "#00B4AB", "Dockerfile": "#384D54",
            "Elixir": "#6E4A7E", "Emacs Lisp": "#C065DB", "Erlang": "#B83998", "F#": "#B845FC", "F*": "#572E30",
            "Factor": "#636746", "Fennel": "#FFF3D7", "GDScript": "#355570", "Gherkin": "#5B2063",
            "GLSL": "#5686A5", "Go": "#00ADD8", "Groovy": "#4298B8", "Hack": "#878787", "Haskell": "#5E5086",
            "HTML": "#E34C26", "Idris": "#B30000", "Java": "#B07219", "JavaScript": "#F1E05A",
            "Jsonnet": "#0064BD", "Julia": "#A270BA", "Jupyter Notebook": "#DA5B0B", "Kotlin": "#A97BFF",
            "LiveScript": "#499886", "Lua": "#000080", "Markdown": "#083FA1", "MATLAB": "#E16737",
            "Makefile": "#427819", "Mathematica": "#DD1100", "Mustache": "#724B3B", "Nim": "#FFC200",
            "Objective-C": "#438EFF", "OCaml": "#3BE133", "Odin": "#60AFFE", "P4": "#7055B5", "Perl": "#0298C3",
            "PHP": "#4F5D95", "PowerShell": "#012456", "Processing": "#0096D8", "Python": "#3572A5",
            "R": "#198CE7", "Red": "#F50000", "ReScript": "#ED5051", "Ruby": "#701516", "Rust": "#DEA584",
            "Scala": "#C22D40", "Scheme": "#1E4AEC", "Shell": "#89E051", "Smalltalk": "#596706",
            "Solidity": "#AA6746", "SQL": "#E38C00", "Standard ML": "#DC566D", "Starlark": "#76D275",
            "Swift": "#F05138", "TeX": "#3D6117", "TypeScript": "#3178C6", "V": "#4F87C4",
            "Vim Script": "#199F4B", "Vue": "#41B883", "WebAssembly": "#04133B", "Wren": "#383838",
            "YASnippet": "#32AB90", "Zig": "#EC915C"
        ]
        static let filters = [
            "all".localized(), "Assembly", "Astro", "C", "C++", "C#", "CSS", "Dart", "Go", "HTML",
            "Java", "JavaScript", "Kotlin", "Makefile", "Markdown", "Objective-C", "Perl", "PHP",
            "Python", "Ruby", "Rust", "Scala", "Shell", "Swift", "TypeScript", "Vue"
        ]
    }
    
    func fetchRepositories(page: Int) {
        isFetching = true
        dataProtocol.fetchTrendingRepositories(
            language: selectedLanguage, perPage: pageItemCount, page: page
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            self.isFetching = false
            switch result {
            case .success(let response):
                self.totalCount = response.totalCount
                let dataItems = response.items.map {
                    let item = self.createPresentationFrom(
                        $0, index: self.repositories.count, isExpanded: false
                    )
                    self.repositories.append($0)
                    self.expandStates.append(item.isExpanded)
                    return PresentationType.data(item: item)
                }
                self.changeHandler?(.showSearch(filters: Const.filters, selectedIndex: self.selectedFilterIndex))
                self.changeHandler?(.items(items: dataItems))
                if self.repositories.count >= self.totalCount {
                    self.changeHandler?(.paginationEnded)
                }
            case .failure(_):
                self.changeHandler?(.hideSearch)
                self.changeHandler?(.error)
            }
        }
    }
    
    func createPresentationFrom(
        _ repository: Repository, index: Int, isExpanded: Bool
    ) -> TrendingRepositoryPresentation {
        let owner = OwnerPresentation(
            imageUrl: repository.owner.avatarUrl, name:  repository.owner.login
        )
        var languagePresentation: LanguagePresentation? = nil
        if let language = repository.language {
            languagePresentation = LanguagePresentation(
                name: language, colorHex: Const.colorsDictionary[language] ?? "#CCCCCC"
            )
        }
        let count = numberFormatter.string(from: NSNumber(value: repository.starCount))
        let index = "#" + String(index + 1)
        return TrendingRepositoryPresentation(
            index: index, owner: owner, title: repository.name, description: repository.description,
            language: languagePresentation, starCount: count ?? "",
            shouldDisplayInfoButton: !(repository.homepage?.isEmpty ?? true), isExpanded: isExpanded
        )
    }
}
