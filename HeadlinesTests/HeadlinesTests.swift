//
//  HeadlinesTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
@testable import Headlines

class HeadlinesTests: XCTestCase {


  }

  func test_articles_are_downloaded_through_network_on_first_fetch() throws {
    let services = HeadlineServices.mock
    let model = HeadlinesModel(services: services)
    let storage = model.services.storageService as? MockStorageService
    XCTAssert(storage?.retrievedFromStorage == false)
    XCTAssertEqual(model.allArticles, [])
    let expect = expectation(description: "Article fetched from network")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    XCTAssert(storage?.retrievedFromStorage == false)
    XCTAssertEqual(model.allArticles.count, 2)
    XCTAssertEqual(model.allArticles[0].headline,
                   "Rishi Sunak to announce £15bn green finance plan")
    XCTAssertEqual(model.allArticles[1].headline, """
Huawei finance chief faces setback in fight against US extradition
""")
  }

  func test_articles_are_cached_for_second_fetch() throws {
    let services = HeadlineServices.mock
    let model = HeadlinesModel(services: services)
    let storage = model.services.storageService as? MockStorageService
    XCTAssert(storage?.retrievedFromStorage == false)
    XCTAssertEqual(model.allArticles, [])
    let expect = expectation(description: "Article fetched from storage")
    services.setDelegate(delegate: model) {
      model.allArticles = []
      model.fetchArticles {
        expect.fulfill()
      }
    }
    wait(for: [expect], timeout: 10)
    XCTAssert(storage?.retrievedFromStorage == true)
    XCTAssertEqual(model.allArticles.count, 2)
    XCTAssertEqual(model.allArticles[0].headline,
                   "Rishi Sunak to announce £15bn green finance plan")
    XCTAssertEqual(model.allArticles[1].headline, """
Huawei finance chief faces setback in fight against US extradition
""")
  }
}
