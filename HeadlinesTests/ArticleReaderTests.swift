//
//  ArticleReaderTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 01/09/2021.
//

import XCTest
import RealmSwift
@testable import Headlines

final class ArticleReaderTests: XCTestCase {

  let mockArticle = MockArticle.articleOne
  private let realmStorageQueue = realmQueue

  func test_article_reader_properties_parsed_correctly() throws {
    let network = MockNetworkService()
    let reader = ArticleReader(article: mockArticle,
                               networkService: network)
    XCTAssert(reader.networkService is MockNetworkService)

    let readerId = reader.id
    let readerHeadline = reader.headline
    let readerBody = reader.body
    let readerImageURL = reader.imageURL?.absoluteString
    let readerFavourite = reader.isFavourite
    let readerPublished = reader.published
    let readerImageData = reader.imageData()

    realmStorageQueue.sync {
      XCTAssertEqual(readerId, mockArticle.id)
      XCTAssertEqual(readerHeadline, mockArticle.headline)
      XCTAssertEqual(readerBody, mockArticle.body)
      XCTAssertEqual(readerImageURL, mockArticle.rawImageURL)
      XCTAssertEqual(readerFavourite, mockArticle.isFavourite)
      XCTAssertEqual(readerPublished,
                     DateFormatter.headlines.string(from: mockArticle.published!))
      XCTAssertNotNil(readerImageData)
    }
  }
}
