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
    
    override func tearDownWithError() throws {
        viewModel = nil
        changes = []
    }
    
    func testFetchItemsSuccess() {
        initializeViewModel(dataProcotol: TrendingRepositoriesSuccessMockService())
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        XCTAssertTrue(changes.removeFirst() == .loading)
        XCTAssertTrue(changes.removeFirst() == .items(items: []))
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchItemsError() {
        initializeViewModel(dataProcotol: TrendingRepositoriesErrorMockService())
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        XCTAssertTrue(changes.removeFirst() == .loading)
        XCTAssertTrue(changes.removeFirst() == .error)
        XCTAssertTrue(changes.isEmpty)
    }
}

// MARK: - Helpers

private extension TrendingRepositoriesViewModelTests {
    
    func initializeViewModel(dataProcotol: TrendingRepositoriesDataProtocol) {
        viewModel = TrendingRepositoriesViewModel(dataProtocol: dataProcotol)
        viewModel.changeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
}
