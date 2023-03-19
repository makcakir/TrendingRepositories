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
    private var fakeRouter: TrendingRepositoriesFakeRouter!
    private var viewModel: TrendingRepositoriesViewModel!
    private var changes: [TrendingRepositoriesViewModel.Change] = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeService = TrendingRepositoriesFakeService()
        fakeRouter = TrendingRepositoriesFakeRouter()
        viewModel = TrendingRepositoriesViewModel(
            pageItemCount: 2, dataProtocol: fakeService, router: fakeRouter, dispatchGroup: FakeDispatchGroup()
        )
        viewModel.changeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        fakeService = nil
        fakeRouter = nil
        viewModel = nil
        changes = []
    }
    
    func testLoadingState() throws {
        viewModel.fetchRepositories()
        
        XCTAssertEqual(changes.count, 3)
        
        let change = changes.removeFirst()
        guard case .loading(let items) = change else {
            XCTFail("Expected change is \".loading\", received \".\(change)\"")
            return
        }
        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.allSatisfy { $0 == .loading })
        
        // .hideSearch change ignored intentionally!
        changes.removeFirst()
        
        // .error change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchRepositoriesError() throws {
        viewModel.fetchRepositories()
        
        XCTAssertEqual(changes.count, 3)
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertEqual(changes.removeFirst(), .hideSearch)
        
        XCTAssertEqual(changes.removeFirst(), .error)
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testFetchRepositoriesSuccess() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        XCTAssertEqual(changes.count, 3)
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        let change1 = changes.removeFirst()
        guard case .showSearch(let filters, let selectedIndex) = change1 else {
            XCTFail("Expected change is \".showSearch\", received \".\(change1)\"")
            return
        }
        XCTAssertEqual(filters.count, 26)
        XCTAssertEqual(selectedIndex, 0)
        
        let change2 = changes.removeFirst()
        guard case .items(let items, let resultMessage) = change2 else {
            XCTFail("Expected change is \".items\", received \".\(change2)\"")
            return
        }
        let message = "resultMessage".localized()
        XCTAssertEqual(resultMessage, String(format: message, "3"))
        XCTAssertEqual(items.count, 2)
        guard case .data(let presentation1) = items[0] else {
            XCTFail("Expected type is \".data\", received \".\(items[0])\"")
            return
        }
        XCTAssertEqual(presentation1.owner.imageUrl.absoluteString, "https://avatars.apple.com")
        XCTAssertEqual(presentation1.owner.name, "apple")
        XCTAssertEqual(presentation1.title, "swift")
        XCTAssertEqual(presentation1.description, "The Swift Programming Language")
        XCTAssertEqual(presentation1.language?.name, "C++")
        XCTAssertEqual(presentation1.language?.colorHex, "#F34B7D")
        XCTAssertEqual(presentation1.starCount, "61,983")
        XCTAssertTrue(presentation1.shouldDisplayInfoButton)
        XCTAssertFalse(presentation1.isExpanded)
        guard case .data(let presentation2) = items[1] else {
            XCTFail("Expected type is \".data\", received \".\(items[1])\"")
            return
        }
        XCTAssertEqual(presentation2.owner.imageUrl.absoluteString, "https://avatars.akullpp.com")
        XCTAssertEqual(presentation2.owner.name, "akullpp")
        XCTAssertEqual(presentation2.title, "awesome-java")
        XCTAssertEqual(presentation2.description, "A curated list of awesome frameworks")
        XCTAssertNil(presentation2.language)
        XCTAssertEqual(presentation2.starCount, "35,638")
        XCTAssertFalse(presentation2.shouldDisplayInfoButton)
        XCTAssertFalse(presentation2.isExpanded)
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testSelection() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.selectRepositoryAt(0)
        
        XCTAssertEqual(changes.count, 1)
        
        let change1 = changes.removeFirst()
        guard case .selected(let selectedItem, let index) = change1 else {
            XCTFail("Expected change is \".selected\", received \".\(change1)\"")
            return
        }
        XCTAssertEqual(index, 0)
        guard case .data(let presentation) = selectedItem else {
            XCTFail("Expected type is \".data\", received \".\(selectedItem)\"")
            return
        }
        XCTAssertTrue(presentation.isExpanded)
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.selectRepositoryAt(0)
        
        XCTAssertEqual(changes.count, 1)
        
        let change2 = changes.removeFirst()
        guard case .selected(let selectedItem, let index) = change2 else {
            XCTFail("Expected change is \".selected\", received \".\(change2)\"")
            return
        }
        XCTAssertEqual(index, 0)
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
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.fetchNextPage()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        let change = changes.removeFirst()
        guard case .items(let items, _) = change else {
            XCTFail("Expected change is \".items\", received \".\(change)\"")
            return
        }
        
        XCTAssertEqual(items.count, 1)
        guard case .data(let presentation1) = items[0] else {
            XCTFail("Expected type is \".data\", received \".\(items[0])\"")
            return
        }
        XCTAssertEqual(presentation1.owner.imageUrl.absoluteString, "https://avatars.bazelbuild.com")
        XCTAssertEqual(presentation1.owner.name, "bazelbuild")
        XCTAssertEqual(presentation1.title, "bazel")
        XCTAssertEqual(presentation1.description, "a fast, scalable, multi-language and extensible build system")
        XCTAssertEqual(presentation1.language?.name, "Java")
        XCTAssertEqual(presentation1.language?.colorHex, "#B07219")
        XCTAssertEqual(presentation1.starCount, "20,432")
        XCTAssertTrue(presentation1.shouldDisplayInfoButton)
        XCTAssertFalse(presentation1.isExpanded)
        
        let change2 = changes.removeFirst()
        guard case .paginationEnded = change2 else {
            XCTFail("Expected change is \".paginationEnded\", received \".\(change2)\"")
            return
        }
        
        XCTAssertTrue(changes.isEmpty)
    }
    
    func testOpenRepositoryDetail() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        XCTAssertNil(fakeRouter.url?.absoluteString)
        
        viewModel.openRepositoryDetailAt(0)
        
        XCTAssertTrue(changes.isEmpty)
        XCTAssertEqual(fakeRouter.url?.absoluteString, "https://github.com/apple/swift")
    }
    
    func testOpenHomepage() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        XCTAssertNil(fakeRouter.url?.absoluteString)
        
        viewModel.openHomepageAt(0)
        
        XCTAssertTrue(changes.isEmpty)
        XCTAssertEqual(fakeRouter.url?.absoluteString, "https://swift.org")
    }
    
    func testFilter() throws {
        fakeService.setupSuccessData()
        viewModel.fetchRepositories()
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        // .items change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
        
        viewModel.selectFilterAt(4)
        
        // .loading change ignored intentionally!
        changes.removeFirst()
        
        // .showSearch change ignored intentionally!
        changes.removeFirst()
        
        let change = changes.removeFirst()
        guard case .items(let items, _) = change else {
            XCTFail("Expected change is \".items\", received \".\(change)\"")
            return
        }
        XCTAssertEqual(items.count, 1)
        guard case .data(let presentation1) = items[0] else {
            XCTFail("Expected type is \".data\", received \".\(items[0])\"")
            return
        }
        XCTAssertEqual(presentation1.owner.imageUrl.absoluteString, "https://avatars.apple.com")
        XCTAssertEqual(presentation1.owner.name, "apple")
        XCTAssertEqual(presentation1.title, "swift")
        XCTAssertEqual(presentation1.description, "The Swift Programming Language")
        XCTAssertEqual(presentation1.language?.name, "C++")
        XCTAssertEqual(presentation1.language?.colorHex, "#F34B7D")
        XCTAssertEqual(presentation1.starCount, "61,983")
        XCTAssertTrue(presentation1.shouldDisplayInfoButton)
        XCTAssertFalse(presentation1.isExpanded)
        
        // .paginationEnded change ignored intentionally!
        changes.removeFirst()
        
        XCTAssertTrue(changes.isEmpty)
    }
}
