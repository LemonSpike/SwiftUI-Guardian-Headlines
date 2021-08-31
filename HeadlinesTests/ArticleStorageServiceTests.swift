//
//  ArticleStorageServiceTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 30/08/2021.
//

import XCTest
import RealmSwift
@testable import Headlines

final class ArticleStorageServiceTests: XCTestCase {

  private var mockModel: MockStorageDelegate = .init()
  private var storageService: ArticleStorageService = .init(realmMode: .inMemory)
  private var realm: Realm?
  private let realmStorageQueue = realmQueue

  override func setUpWithError() throws {
    storageService = ArticleStorageService(realmMode: .inMemory,
                                           realmStorageQueue: realmStorageQueue)
    realm = storageService.realm
    mockModel = MockStorageDelegate()
    storageService.delegate = mockModel
  }

  override func tearDownWithError() throws {
    try realmStorageQueue.sync {
      try realm?.write {
        realm?.deleteAll()
      }
    }
  }

  func test_persist_fails_with_invalid_realm_instance() throws {
    storageService.realm = nil
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
    storageService.realm = nil
    storageService.retrieveAllArticlesFromStorage()
    XCTAssertEqual(mockModel.allArticles, [])
  }

  func test_persist_updates_realm() throws {
    storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                MockArticle.articleTwo], nil)
    realmStorageQueue.sync {
      XCTAssertEqual(realm?.objects(Article.self).count, 2)
      XCTAssertEqual(MockArticle.articleOne.headline,
                     realm?.objects(Article.self)[0].headline)
      XCTAssertEqual(MockArticle.articleTwo.headline,
                     realm?.objects(Article.self)[1].headline)
    }
  }

  func test_retrieve_updates_delegate() throws {
    storageService.persistAllArticlesToStorage([MockArticle.articleOne,
                                                MockArticle.articleTwo], nil)
    storageService.retrieveAllArticlesFromStorage()

    XCTAssertEqual(mockModel.allArticles.count, 2)

    realmStorageQueue.sync {
      XCTAssertEqual(MockArticle.articleOne.headline,
                     mockModel.allArticles[0].headline)
      XCTAssertEqual(MockArticle.articleTwo.headline,
                     mockModel.allArticles[1].headline)
    }
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
    storageService.realm = nil
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
    var delegateReader = ArticleReader(article: mockModel.allArticles[0],
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
    delegateReader = ArticleReader(article: mockModel.allArticles[0],
                                   networkService: MockNetworkService())
    XCTAssert(delegateReader.isFavourite)
  }
}
