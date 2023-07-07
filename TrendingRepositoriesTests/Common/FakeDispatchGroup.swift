//
//  FakeDispatchGroup.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 17.03.2023.
//

import Foundation
@testable import TrendingRepositories

final class FakeDispatchGroup {}

extension FakeDispatchGroup: DispatchGroupProtocol {

    func enter() {
        // Left blank intentionally!
    }

    func leave() {
        // Left blank intentionally!
    }

    func notify(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
