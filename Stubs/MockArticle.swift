//
//  MockArticles.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation
@testable import Headlines

struct MockArticle {
  static let articleOne: Article = {
    let article = Article()
    article.headline = "Rishi Sunak to announce £15bn green finance plan"
    article.rawImageURL = "https://media.guim.co.uk/" +
      "e1526d226af53c8ed55d50fda12e8ba0776c5328/0_123_3500_2101/1000.jpg"
    article.isFavourite = false
    article.published = ISO8601DateFormatter()
      .date(from: "2021-06-30T23:01:51Z")
    let body = Bundle(for: HeadlinesTests.self).bundlePath + "/headline_stub_body.txt"
    article.body = try! String(contentsOfFile: body)
    return article
  }()
}
