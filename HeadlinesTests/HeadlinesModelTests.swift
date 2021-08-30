//
//  HeadlinesModelTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
@testable import Headlines

class HeadlinesModelTests: XCTestCase {

  var services: HeadlineServices = .mock
  var model: HeadlinesModel = .init(services: .mock)

  override func setUp() {
    services = .mock
    model = .init(services: services)
  }

  func test_articles_are_downloaded_through_network_on_first_fetch() throws {
    let storage = model.services.storageService as? MockStorageService
    XCTAssertEqual(storage?.retrievedFromStorage , false)
    XCTAssertEqual(model.allArticles, [])
    let expect = expectation(description: "Article fetched from network")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    XCTAssertEqual(storage?.retrievedFromStorage , false)
    XCTAssertEqual(model.allArticles.count, 2)
    XCTAssertEqual(model.allArticles[0].headline,
                   "Rishi Sunak to announce £15bn green finance plan")
    XCTAssertEqual(model.allArticles[1].headline, """
Huawei finance chief faces setback in fight against US extradition
""")
  }

  func test_articles_are_cached_for_second_fetch() throws {
    let storage = model.services.storageService as? MockStorageService
    XCTAssertEqual(storage?.retrievedFromStorage, false)
    XCTAssertEqual(model.allArticles, [])
    let expect = expectation(description: "Article fetched from storage")
    services.setDelegate(delegate: model) { [weak self] in
      self?.model.allArticles = []
      self?.model.fetchArticles {
        expect.fulfill()
      }
    }
    wait(for: [expect], timeout: 10)
    XCTAssertEqual(storage?.retrievedFromStorage, true)
    XCTAssertEqual(model.allArticles.count, 2)
    XCTAssertEqual(model.allArticles[0].headline,
                   "Rishi Sunak to announce £15bn green finance plan")
    XCTAssertEqual(model.allArticles[1].headline, """
Huawei finance chief faces setback in fight against US extradition
""")
  }

  func test_model_number_of_articles() throws {
    XCTAssertEqual(model.allArticles.count, 0)
    let expect = expectation(description: "Articles fetched")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    XCTAssert(model.allArticles.count > 0)
    XCTAssertEqual(model.allArticles.count, model.numberOfArticles)
  }

  func test_model_current_article() throws {
    XCTAssertNil(model.currentArticle)
    XCTAssertEqual(model.allArticles, [])
    let expect = expectation(description: "Articles fetched")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    XCTAssertEqual(model.allArticles.first, model.currentArticle)
  }

  func test_model_current_article_updates_after_swipe_left() throws {
    let expect = expectation(description: "Articles fetched")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    model.didSwipeArticleLeft()
    XCTAssertEqual(model.allArticles[1], model.currentArticle)
  }

  func test_model_current_article_updates_after_swipe_right() throws {
    let expect = expectation(description: "Articles fetched")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)

    model.didSwipeArticleLeft()
    model.didSwipeArticleRight()
    XCTAssertEqual(model.allArticles[0], model.currentArticle)
  }

  func test_toggle_article_is_favourited_in_storage() throws {
    let expect = expectation(description: "Articles fetched")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    model.toggleFavourite()
    XCTAssertEqual(model.currentArticle?.isFavourite, true)
  }

  func test_error_not_nil_toggles_show_article() throws {
    XCTAssertFalse(model.showAlert)
    model.error = HeadlinesError.emptyPayload
    XCTAssert(model.showAlert)
  }
}