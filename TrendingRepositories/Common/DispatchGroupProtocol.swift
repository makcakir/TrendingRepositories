//
//  DispatchGroupProtocol.swift
//  TrendingRepositories
//
//  Created by Mustafa Ali Akçakır on 17.03.2023.
//

import Foundation

protocol DispatchGroupProtocol {

    func enter()

    func leave()

    func notify(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchGroup: DispatchGroupProtocol {

    func notify(execute work: @escaping @convention(block) () -> Void) {
        notify(queue: .main) {
            work()
        }
    }
}
