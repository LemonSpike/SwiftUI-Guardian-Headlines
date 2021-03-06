//
//  HeadlinesJSONParsingTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 30/08/2021.
//

import XCTest
@testable import Headlines

final class HeadlinesJSONParsingTests: XCTestCase {

  func test_article_decodes_from_json_correctly_and_strips_html() throws {

    let jsonData = mockFixture(moduleFor: Self.self, name: "headline_stub.json")
    let response = try JSONDecoder().decode(HeadlinesResponse.self,
                                            from: jsonData)

    // Realm objects have a custom Equatable method.
    // Thus, we need to manually check each property.
    let parsed = response.articles[0]
    let correct = MockArticle.articleOne
    XCTAssertEqual(parsed.isFavourite,
                   correct.isFavourite)
    XCTAssertEqual(parsed.body,
                   correct.body)
    XCTAssertEqual(parsed.headline,
                   correct.headline)
    XCTAssertEqual(parsed.published,
                   correct.published)
    XCTAssertEqual(parsed.rawImageURL,
                   correct.rawImageURL)
  }

  func test_multiple_articles_are_decoded_from_json() throws {
    let jsonData = mockFixture(moduleFor: Self.self, name: "two_headline_stub.json")
    let response = try JSONDecoder().decode(HeadlinesResponse.self,
                                            from: jsonData)

    XCTAssertEqual(response.articles.count, 2)
    XCTAssertEqual(response.articles.first?.headline,
                   "Rishi Sunak to announce £15bn green finance plan")
    XCTAssertEqual(response.articles[1].headline, """
Huawei finance chief faces setback in fight against US extradition
""")
  }

  /* TODO: If I had more time I would add performance tests for larger JSON file
   de-serialization.
   */
}
