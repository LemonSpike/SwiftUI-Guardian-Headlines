//
//  HeadlinesTests.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
@testable import Headlines

class HeadlinesTests: XCTestCase {

  func test_article_decodes_from_json_correctly_and_strips_html() throws {
    let stub = Bundle(for: Self.self).bundlePath + "/headline_stub.json"
    let jsonData = try String(contentsOfFile: stub).data(using: .unicode)!
    let response = try JSONDecoder().decode(HeadlineResponse.self,
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

/* TODO: If I had more time I would add performance tests for larger JSON file
   de-serialization.
*/
}
