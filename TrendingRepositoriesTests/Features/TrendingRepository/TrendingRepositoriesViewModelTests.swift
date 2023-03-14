//
//  TrendingRepositoriesViewModelTests.swift
//  TrendingRepositoriesTests
//
//  Created by Mustafa Ali Akçakır on 11.01.2023.
//

import XCTest
@testable import TrendingRepositories

final class TrendingRepositoriesViewModelTests: XCTestCase {
    
    private var fakeService: TrendingRepositoriesFakeService!
    private var viewModel: TrendingRepositoriesViewModel!
    private var changes: [TrendingRepositoriesViewModel.Change] = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeService = TrendingRepositoriesFakeService()
        viewModel = TrendingRepositoriesViewModel(dataProtocol: fakeService, pageItemCount: 2)
        viewModel.changeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        fakeService = nil
        viewModel = nil
        changes = []
    }
    
    func testLoadingState() throws {
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        
        let change = changes.removeFirst()
        guard case .loading(let items) = change else {
            XCTFail("Expected change is \".loading\", received \".\(change)\"")
            return
        }
        XCTAssertTrue(items.count == 2)
        XCTAssertTrue(items.allSatisfy { $0 == .loading })
        
        // .error change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchRepositoriesError() throws {
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.removeFirst() == .error)
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchRepositoriesSuccess() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        XCTAssertTrue(changes.count == 2)
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        let change = changes.removeFirst()
        guard case .items(let items) = change else {
            XCTFail("Expected change is \".items\", received \".\(change)\"")
            return
        }
        
        XCTAssertTrue(items.count == 2)
        guard case .data(let presentation1) = items[0] else {
            XCTFail("Expected type is \".data\", received \".\(items[0])\"")
            return
        }
        XCTAssertTrue(presentation1.owner.imageUrl == "https://avatars.apple.com")
        XCTAssertTrue(presentation1.owner.name == "apple")
        XCTAssertTrue(presentation1.title == "swift")
        XCTAssertTrue(presentation1.description == "The Swift Programming Language")
        XCTAssertTrue(presentation1.language?.name == "C++")
        XCTAssertTrue(presentation1.language?.colorHex == "#F34B7D")
        XCTAssertTrue(presentation1.starCount == "61,983")
        XCTAssertFalse(presentation1.isExpanded)
        guard case .data(let presentation2) = items[1] else {
            XCTFail("Expected type is \".data\", received \".\(items[1])\"")
            return
        }
        XCTAssertTrue(presentation2.owner.imageUrl == "https://avatars.akullpp.com")
        XCTAssertTrue(presentation2.owner.name == "akullpp")
        XCTAssertTrue(presentation2.title == "awesome-java")
        XCTAssertTrue(presentation2.description == "A curated list of awesome frameworks")
        XCTAssertNil(presentation2.language)
        XCTAssertTrue(presentation2.starCount == "35,638")
        XCTAssertFalse(presentation2.isExpanded)
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testSelection() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.selectRepositoryAt(0)
        
        XCTAssertTrue(changes.count == 1)
        
        let change1 = changes.removeFirst()
        guard case .selected(let selectedItem, let index) = change1 else {
            XCTFail("Expected change is \".items\", received \".\(change1)\"")
            return
        }
        XCTAssertTrue(index == 0)
        guard case .data(let presentation) = selectedItem else {
            XCTFail("Expected type is \".data\", received \".\(selectedItem)\"")
            return
        }
        XCTAssertTrue(presentation.isExpanded)
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.selectRepositoryAt(0)
        
        XCTAssertTrue(changes.count == 1)
        
        let change2 = changes.removeFirst()
        guard case .selected(let selectedItem, let index) = change2 else {
            XCTFail("Expected change is \".items\", received \".\(change2)\"")
            return
        }
        XCTAssertTrue(index == 0)
        guard case .data(let presentation) = selectedItem else {
            XCTFail("Expected type is \".data\", received \".\(selectedItem)\"")
            return
        }
        XCTAssertFalse(presentation.isExpanded)
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testPagination() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.fetchNextPage()
        
        let change = changes.removeFirst()
        guard case .items(let items) = change else {
            XCTFail("Expected change is \".items\", received \".\(change)\"")
            return
        }
        
        XCTAssertTrue(items.count == 1)
        guard case .data(let presentation1) = items[0] else {
            XCTFail("Expected type is \".data\", received \".\(items[0])\"")
            return
        }
        XCTAssertTrue(presentation1.owner.imageUrl == "https://avatars.bazelbuild.com")
        XCTAssertTrue(presentation1.owner.name == "bazelbuild")
        XCTAssertTrue(presentation1.title == "bazel")
        XCTAssertTrue(presentation1.description == "a fast, scalable, multi-language and extensible build system")
        XCTAssertTrue(presentation1.language?.name == "Java")
        XCTAssertTrue(presentation1.language?.colorHex == "#B07219")
        XCTAssertTrue(presentation1.starCount == "20,432")
        XCTAssertFalse(presentation1.isExpanded)
        
        let change2 = changes.removeFirst()
        guard case .paginationEnded = change2 else {
            XCTFail("Expected change is \".paginationEnded\", received \".\(change2)\"")
            return
        }
        
        XCTAssertTrue(changes.isEmpty)
    }
}
