//
//  HeadlinesUITests.swift
//  HeadlinesUITests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift

class HeadlinesUITests: XCTestCase {

  override func setUpWithError() throws {
    stub(condition: isHost("content.guardianapis.com")) { _ in
      return HTTPStubsResponse(
        fileAtPath: OHPathForFile("two_headline_stub.json", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type": "application/json"]
      )
    }

    stub(condition: isHost("media.guim.co.uk")) { _ in
      return HTTPStubsResponse(
        fileAtPath: OHPathForFile("headline_one_img.jpg", type(of: self))!,
        statusCode: 200,
        headers: ["Content-Type": "image/jpeg"]
      )
    }
    HTTPStubs.setEnabled(true)
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
    HTTPStubs.removeAllStubs()
  }

  // This test requires the device/simulator to be reset to clear the article
  // cache.
  func testFailedRequestDisplaysErrorAlert() throws {
    HTTPStubs.removeAllStubs()

    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["An error occurred"]
    XCTAssert(alert.waitForExistence(timeout: 10))

    alert.staticTexts["An error occurred"].tap()
    alert.staticTexts["Please try again later."].tap()
    alert.buttons["Ok"].tap()
  }

  func testOnboardingAlert() throws {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert.waitForExistence(timeout: 5))

    let predicate = NSPredicate(format: "label CONTAINS[c] %@",
                                """
                                Swipe ⬅️ for the next article.
                                Swipe ➡️ for the previous article.
                                Favorite articles with the ⭐️ icon.
                                View your Favourites with the Favourites button.
                                """)
    XCTAssert(alert.staticTexts.containing(predicate).count > 0)
    alert.buttons["Ok"].tap()
  }

  func testArticleSwipeLeftUpdatesArticle() throws {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert
                .waitForExistence(timeout: 5))
    alert.buttons["Ok"].tap()

    XCTAssert(app
                .staticTexts["Rishi Sunak to announce £15bn green finance plan"]
                .waitForExistence(timeout: 5))
    XCTAssert(app.images["articleImage"].waitForExistence(timeout: 5))
    XCTAssert(app.staticTexts["articleBody"].waitForExistence(timeout: 5))

    app.staticTexts["Rishi Sunak to announce £15bn green finance plan"]
      .swipeLeft()

    XCTAssert(app.staticTexts["Huawei finance chief faces setback in fight against US extradition"].waitForExistence(timeout: 5))
    XCTAssert(app.images["articleImage"].waitForExistence(timeout: 5))
    XCTAssert(app.staticTexts["articleBody"].waitForExistence(timeout: 5))
  }

  func testArticleSwipeRightUpdatesArticle() {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert
                .waitForExistence(timeout: 5))
    alert.buttons["Ok"].tap()

    XCTAssert(app.staticTexts["Rishi Sunak to announce £15bn green finance plan"].waitForExistence(timeout: 5))

    app.staticTexts["Rishi Sunak to announce £15bn green finance plan"]
      .swipeLeft()
    XCTAssert(app.staticTexts["Huawei finance chief faces setback in fight against US extradition"].waitForExistence(timeout: 5))

    app.staticTexts["Huawei finance chief faces setback in fight against US extradition"].swipeRight()
    XCTAssert(app.staticTexts["Rishi Sunak to announce £15bn green finance plan"].waitForExistence(timeout: 5))
    XCTAssert(app.images["articleImage"].waitForExistence(timeout: 5))
    XCTAssert(app.staticTexts["articleBody"].waitForExistence(timeout: 5))
  }

  func testFavouritingArticleUpdatesIcon() {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert
                .waitForExistence(timeout: 5))
    alert.buttons["Ok"].tap()

    XCTAssert(app.images["favorite"].waitForExistence(timeout: 5))
    if (!app.images["articleStarIcon"].exists) {
      XCTAssert(app.images["articleStarFillIcon"].waitForExistence(timeout: 5))
      app.images["articleStarFillIcon"].tap()
      XCTAssert(app.images["articleStarIcon"].waitForExistence(timeout: 5))
      app.images["articleStarIcon"].tap()
      XCTAssert(app.images["articleStarFillIcon"].waitForExistence(timeout: 5))
    } else {
      XCTAssert(app.images["articleStarIcon"].waitForExistence(timeout: 5))
      app.images["articleStarIcon"].tap()
      XCTAssert(app.images["articleStarFillIcon"].waitForExistence(timeout: 5))
      app.images["articleStarFillIcon"].tap()
      XCTAssert(app.images["articleStarIcon"].waitForExistence(timeout: 5))
    }
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
          .launch()
      }
    }
  }
}
