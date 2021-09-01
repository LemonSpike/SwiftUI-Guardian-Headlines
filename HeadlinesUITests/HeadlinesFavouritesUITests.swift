//
//  HeadlinesFavouritesUITests.swift
//  HeadlinesUITests
//
//  Created by Pranav Kasetti on 01/09/2021.
//

import XCTest

class HeadlinesFavouritesUITests: XCTestCase {

  func testFavouritingArticleUpdatesIcon() {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert
                .waitForExistence(timeout: 5))
    alert.buttons["Ok"].tap()

    XCTAssert(app.images["favorite"].waitForExistence(timeout: 5))
    if !app.images["articleStarIcon"].exists {
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

  func testFavouriteArticlesInList() {
    let app = XCUIApplication(bundleIdentifier: "com.kasprasolutions.Headlines")
    app.launch()

    let alert = app.alerts["Welcome to Headlines 🗞"]
    XCTAssert(alert
                .waitForExistence(timeout: 5))
    alert.buttons["Ok"].tap()

    XCTAssert(app.images["favorite"].waitForExistence(timeout: 5))
    if !app.images["articleStarIcon"].exists {
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

    app.buttons["Favourites"].tap()
    XCTAssert(app
                .staticTexts["Rishi Sunak to announce £15bn green finance plan"]
                .waitForExistence(timeout: 5))
    XCTAssert(app
                .staticTexts["1 Jul 2021"]
                .waitForExistence(timeout: 5))
    XCTAssert(app
                .staticTexts["1 Favourite Articles"]
                .waitForExistence(timeout: 5))

    XCTAssert(app.images["articleStarFillIcon"].waitForExistence(timeout: 5))
    app.images["articleStarFillIcon"].tap()

    XCTAssert(app
                .staticTexts["0 Favourite Articles"]
                .waitForExistence(timeout: 5))
  }
}
