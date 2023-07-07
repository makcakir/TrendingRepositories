//
//  Base.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 03.04.2023.
//

import UIKit

class Dependency { }

class NetworkDependency: Dependency {

    let network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
}

class ViewModel<DependencyType: Dependency> {

    let dependency: DependencyType

    init(dependency: DependencyType) {
        self.dependency = dependency
    }
}

class ViewController<DependencyType, ViewModelType: ViewModel<DependencyType>>: UIViewController {

    let viewModel: ViewModelType

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
