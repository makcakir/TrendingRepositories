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
        case items(items: [PresentationType])
        case loading(items: [PresentationType])
        case selected(item: PresentationType, index: Int)
    }
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private let dataProtocol: TrendingRepositoriesDataProtocol
    private var expandStates: [Bool] = []
    private var repositories: [Repository] = []
    
    var changeHandler: ((Change) -> Void)?
    
    init(dataProtocol: TrendingRepositoriesDataProtocol) {
        self.dataProtocol = dataProtocol
    }
    
    func fetchRepositories() {
        let loadingItems = [PresentationType](repeating: .loading, count: Const.loadingItemCount)
        changeHandler?(.loading(items: loadingItems))
        
        dataProtocol.fetchTrendingRepositories { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                self.repositories = response.items
                self.expandStates = [Bool](repeating: false, count: response.items.count)
                let dataItems = response.items.map {
                    let item = self.createPresentationFrom($0, isExpanded: false)
                    return PresentationType.data(item: item)
                }
                self.changeHandler?(.items(items: dataItems))
            case .failure(_):
                self.changeHandler?(.error)
            }
        }
    }
    
    func repositorySelectedAt(_ index: Int) {
        guard index < expandStates.count else {
            return
        }
        expandStates[index].toggle()
        let item = createPresentationFrom(repositories[index], isExpanded: expandStates[index])
        changeHandler?(.selected(item: PresentationType.data(item: item), index: index))
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewModel {
    
    enum Const {
        static let loadingItemCount = 20
        static let colorsDictionary = [
            "C": "#555555", "C#": "#178600", "C++": "#F34B7D", "CSS": "#563D7C", "Dart": "#00B4AB",
            "Elixir": "#6E4A7E", "Go": "#00ADD8", "HTML": "#E34C26", "Java": "#B07219",
            "JavaScript": "#F1E05A", "Julia": "#A270BA", "Jupyter Notebook": "#DA5B0B",
            "Kotlin": "#A97BFF", "MATLAB": "#E16737", "Objective-C": "#438EFF", "Perl": "#0298C3",
            "PHP": "#4F5D95", "PowerShell": "#012456", "Python": "#3572A5", "R": "#198CE7",
            "Ruby": "#701516", "Rust": "#DEA584", "Scala": "#C22D40", "Shell": "#89E051",
            "SQL": "#E38C00", "Swift": "#F05138", "TypeScript": "#3178C6", "V": "#4F87C4",
            "Vue": "#41B883", "Zig": "#EC915C"
        ]
    }
    
    private func createPresentationFrom(
        _ repository: Repository, isExpanded: Bool
    ) -> TrendingRepositoryPresentation {
        let owner = OwnerPresentation(
            imageUrl: repository.owner.avatarUrl, name:  repository.owner.login
        )
        var language: LanguagePresentation? = nil
        if let lang = repository.language {
            language = LanguagePresentation(
                name: lang, colorHex: Const.colorsDictionary[lang] ?? "FFFFFF"
            )
        }
        let count = numberFormatter.string(from: NSNumber(value: repository.starCount))
        return TrendingRepositoryPresentation(
            owner: owner, title: repository.name, description: repository.description,
            language: language, starCount: count ?? "", isExpanded: isExpanded
        )
    }
}
