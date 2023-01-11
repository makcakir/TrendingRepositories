//
//  TrendingRepositoriesViewModelTests.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import XCTest
@testable import TrendingRepositories

final class TrendingRepositoriesViewModelTests: XCTestCase {
    
    private var viewModel: TrendingRepositoriesViewModel!
    private var changes: [TrendingRepositoriesViewModel.Change] = []
    
    override func setUpWithError() throws {
        viewModel = TrendingRepositoriesViewModel()
        viewModel.changeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        changes = []
    }
    
    func testFetchItemsSuccess() {
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        XCTAssertTrue(changes.removeFirst() == .loading)
        XCTAssertTrue(changes.removeFirst() == .items)
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchItemsError() {
        viewModel.fetchRepositories(forceError: true)
        
        XCTAssertTrue(changes.count == 2)
        XCTAssertTrue(changes.removeFirst() == .loading)
        XCTAssertTrue(changes.removeFirst() == .error)
        XCTAssertTrue(changes.isEmpty)
    }
    
}
