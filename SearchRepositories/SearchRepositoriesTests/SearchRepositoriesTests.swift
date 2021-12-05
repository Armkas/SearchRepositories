//
//  SearchRepositoriesTests.swift
//  SearchRepositoriesTests
//
//  Created by user on 2021/12/01.
//

import XCTest
@testable import SearchRepositories

class SearchRepositoriesTests: XCTestCase {
    
    let api = MockApi()
    
    func testMockResponse() {
        api.getRepositories(text: "ios") { repositories, error in
            XCTAssertNil(error)
            XCTAssertNotNil(repositories)
            guard let total_count = repositories?.total_count else {
                XCTFail()
                return
            }
            XCTAssertEqual(1, total_count)
            
            guard let items = repositories?.items else {
                XCTFail()
                return
            }
            XCTAssertEqual(1, items.count)
            
            XCTAssertEqual(items[0].name, "Tetris")
            XCTAssertEqual(items[0].full_name, "dtrupenn/Tetris")
            XCTAssertEqual(items[0].html_url, "https://github.com/dtrupenn/Tetris")
        }
        api.reset()
    }
    
    func testMockResponseFailed() {
        api.shouldReturnError = true
        api.getRepositories(text: "ios") { repositories, error in
            XCTAssertNotNil(error)
            XCTAssertNil(repositories)
        }
        api.reset()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
