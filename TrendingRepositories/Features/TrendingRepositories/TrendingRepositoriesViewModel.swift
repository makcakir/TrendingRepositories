//
//  TrendingRepositoriesViewModel.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import Foundation

class TrendingRepositoriesViewModel {
    
    enum Change {
        case error
        case items
        case loading
    }
    
    var changeHandler: ((Change) -> Void)?
    
    func fetchRepositories(forceError: Bool = false) {
        changeHandler?(.loading)
        if forceError {
            changeHandler?(.error)
        } else {
            changeHandler?(.items)
        }
    }
    
}
