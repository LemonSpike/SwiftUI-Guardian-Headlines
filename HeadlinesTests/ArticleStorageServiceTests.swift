//
//  ArticleStorageServiceTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 30/08/2021.
//

import XCTest
import RealmSwift
@testable import Headlines

class ArticleStorageServiceTests: XCTestCase {

  var delegate: MockStorageDelegate = .init()
  var storageService: ArticleStorageService = .init(realm: nil)
  var realm: Realm?

  override func setUpWithError() throws {
    realm = try Realm(configuration:
                        .init(inMemoryIdentifier: "HeadlinesInMemoryRealm"))
    storageService = ArticleStorageService(realm: realm)
    delegate = MockStorageDelegate()
    storageService.delegate = delegate
  }

  override func tearDownWithError() throws {
    try realm?.write {
      realm?.deleteAll()
    }
  }

  func test_persist_fails_with_invalid_realm_instance() throws {
    storageService = .init(realm: nil)
    let expect = XCTestExpectation(description: "Articles persisted")
    var receivedError: HeadlinesError?
    storageService
      .persistAllArticlesToStorage([MockArticle.articleOne,
                                    MockArticle.articleTwo]) { error in
        receivedError = error
        expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
    guard let receivedError = receivedError else {
      XCTFail("No error was thrown.")
      return
    }
    if case HeadlinesError.realmInstanceCreationFailed = receivedError {
      return
    }
    XCTFail("Realm instance was nil but not captured.")
  }

  func test_retrieve_fails_with_invalid_realm_instance() throws {
    storageService = .init(realm: nil)
    storageService.retrieveAllArticlesFromStorage()
    XCTAssertEqual(delegate.allArticles, [])
  }

  func test_persist_updates_realm() throws {
    storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                MockArticle.articleTwo], nil)
    XCTAssertEqual(realm?.objects(Article.self).count, 2)
    XCTAssertEqual(MockArticle.articleOne.headline,
                   realm?.objects(Article.self)[0].headline)
    XCTAssertEqual(MockArticle.articleTwo.headline,
                   realm?.objects(Article.self)[1].headline)
  }

  func test_retrieve_updates_delegate() throws {
    storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                MockArticle.articleTwo], nil)
    storageService.retrieveAllArticlesFromStorage()

    XCTAssertEqual(delegate.allArticles.count, 2)
    XCTAssertEqual(MockArticle.articleOne.headline,
                   delegate.allArticles[0].headline)
    XCTAssertEqual(MockArticle.articleTwo.headline,
                   delegate.allArticles[1].headline)
  }

  func test_performance_of_persist() throws {
    self.measure {
      storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                  MockArticle.articleTwo], nil)
    }
  }

  func test_performance_of_retrieve() throws {
    storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                MockArticle.articleTwo], nil)
    self.measure {
      storageService.retrieveAllArticlesFromStorage()
    }
  }

  func test_favouriting_fails_with_invalid_realm_instance() throws {
    storageService = .init(realm: nil)
    var article = MockArticle.articleOne
    let expect = XCTestExpectation(description: "Articles persisted")
    var receivedError: HeadlinesError?
    storageService
      .toggleArticleIsFavouritedInStorage(&article) { error in
        receivedError = error
        expect.fulfill()
      }
    wait(for: [expect], timeout: 10)
    guard let receivedError = receivedError else {
      XCTFail("No error was thrown.")
      return
    }
    if case HeadlinesError.realmInstanceCreationFailed = receivedError {
      return
    }
    XCTFail("Realm instance was not nil.")
  }

  func test_favouriting_updates_delegate() throws {
    var article = MockArticle.articleOne
    storageService.persistAllArticlesToStorage([article], nil)
    let expect = XCTestExpectation(description: "Articles favourited")
    storageService.retrieveAllArticlesFromStorage()
    var delegateReader = ArticleReader(article: delegate.allArticles[0],
                                       networkService: MockNetworkService())
    XCTAssertFalse(delegateReader.isFavourite)
    var receivedError: HeadlinesError?
    storageService
      .toggleArticleIsFavouritedInStorage(&article) { error in
        receivedError = error
      }
    storageService.retrieveAllArticlesFromStorage()
    expect.fulfill()
    wait(for: [expect], timeout: 10)
    XCTAssertNil(receivedError)
    delegateReader = ArticleReader(article: delegate.allArticles[0],
                                   networkService: MockNetworkService())
    XCTAssert(delegateReader.isFavourite)
  }
}
