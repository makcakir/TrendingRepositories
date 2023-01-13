//
//  TrendingRepositoriesViewModel.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

final class TrendingRepositoriesViewModel {
    
    enum Change: Equatable {
        case error
        case items(items: [TrendingRepositoryPresentation])
        case loading
        
        static func == (
            lhs: TrendingRepositoriesViewModel.Change, rhs: TrendingRepositoriesViewModel.Change
        ) -> Bool {
            switch (lhs, rhs) {
            case (.error, .error):
                return true
            case (.items(let lhsItems), .items(let rhsItems)):
                return lhsItems == rhsItems
            case (.loading, .loading):
                return true
            default:
                return false
            }
        }
    }
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private let dataProtocol: TrendingRepositoriesDataProtocol
    
    var changeHandler: ((Change) -> Void)?
    
    init(dataProtocol: TrendingRepositoriesDataProtocol) {
        self.dataProtocol = dataProtocol
    }
    
    func fetchRepositories() {
        changeHandler?(.loading)
        
        dataProtocol.fetchTrendingRepositories { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                let items = response.items.map {
                    let owner = OwnerPresentation(
                        imageUrl: $0.owner.avatarUrl, name:  $0.owner.login
                    )
                    var language: LanguagePresentation? = nil
                    if let lang = $0.language {
                        language = LanguagePresentation(
                            name: lang, colorHex: Const.colorsDictionary[lang] ?? "FFFFFF"
                        )
                    }
                    let count = self.numberFormatter.string(from: NSNumber(value: $0.starCount))
                    return TrendingRepositoryPresentation(
                        owner: owner, title: $0.name, description: $0.description,
                        language: language, starCount: count ?? "", isExpanded: false
                    )
                }
                self.changeHandler?(.items(items: items))
            case .failure(_):
                self.changeHandler?(.error)
            }
        }
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewModel {
    
    enum Const {
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
}
