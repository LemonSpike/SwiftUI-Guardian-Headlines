//
//  HeadlinesUITests.swift
//  HeadlinesUITests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import Headlines

class HeadlinesUITests: XCTestCase {

  override func setUpWithError() throws {
    stub(condition: isHost("content.guardianapis.com")) { request in
      return HTTPStubsResponse(
        fileAtPath: OHPathForFile("headline_stub.json", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type":"application/json"]
      )
    }
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
    HTTPStubs.removeAllStubs()
  }

  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
