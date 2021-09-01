//
//  HeadlinesModel+FavouritesTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
@testable import Headlines

final class HeadlinesModelFavouritesTests: XCTestCase {

  private var services: HeadlineServices = .mock
  private var model: HeadlinesModel = .init(services: .mock)

  override func setUp() {
    services = .mock
    model = .init(services: services)
    fetch_articles()
  }

  func fetch_articles() {
    let expect = expectation(description: "Article fetched from network")
    services.setDelegate(delegate: model) {
      expect.fulfill()
    }
    wait(for: [expect], timeout: 10)
  }

  func test_favourite_articles() throws {
    model.toggleFavourite()
    XCTAssertEqual(model.numberOfFavouritedArticles, 1)
    XCTAssertEqual(model.favouritedArticles[0].id, model.allArticles[0].id)
    model.didSwipeArticleLeft()
    model.toggleFavourite()
    XCTAssertEqual(model.numberOfFavouritedArticles, 2)
    XCTAssertEqual(model.favouritedArticles[1].id, model.allArticles[1].id)
  }

  func test_unfavourite_article() throws {
    model.toggleFavourite()
    model.didSwipeArticleLeft()
    model.toggleFavourite()
    XCTAssertEqual(model.numberOfFavouritedArticles, 2)
    model.didSwipeArticleRight()
    model.toggleFavourite()
    XCTAssertEqual(model.numberOfFavouritedArticles, 1)
    XCTAssertEqual(model.favouritedArticles[0].id, model.allArticles[1].id)
  }

  func test_did_select_favourite_article() throws {
    model.toggleFavourite()
    model.didSwipeArticleLeft()
    model.didSelectFavouritedArticle(article: ArticleReader(article: model.allArticles[0],
                                                            networkService: MockNetworkService()))
    XCTAssertEqual(model.currentIndex, 0)
    XCTAssertEqual(model.currentArticle?.article, model.allArticles[0])
  }

  func test_did_deselect_favourite_article() throws {
    model.didSwipeArticleLeft()
    model.toggleFavourite()
    let article = ArticleReader(article: model.allArticles[1],
                                networkService: MockNetworkService())
    XCTAssertEqual(model.favouritedArticles.count, 1)
    model.didDeselectFavouritedArticle(article: article)
    XCTAssertEqual(model.favouritedArticles.count, 0)
  }
}
