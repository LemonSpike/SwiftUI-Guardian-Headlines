//
//  MockArticles.swift
//  HeadlinesTests
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation

final class MockArticle {
  static var articleOne: Article {
    let article = Article()
    article.headline = "Rishi Sunak to announce £15bn green finance plan"
    article.rawImageURL = "https://media.guim.co.uk/" +
      "e1526d226af53c8ed55d50fda12e8ba0776c5328/0_123_3500_2101/1000.jpg"
    article.isFavourite = false
    article.published = ISO8601DateFormatter()
      .date(from: "2021-06-30T23:01:51Z")
    let data = mockFixture(moduleFor: MockArticle.self,
                           name: "headline_stub_body.txt")
    article.body = String(data: data, encoding: .utf8)!
    return article
  }

  static var articleTwo: Article {
    let article = Article()
    article.headline = "Huawei finance chief faces setback in fight against US extradition"
    article.rawImageURL = "https://media.guim.co.uk/" +
      "75ed9fabe90eb6495a12780a1e7683b6a42b8a2c/0_0_3500_2100/1000.jpg"
    article.isFavourite = false
    article.published = ISO8601DateFormatter()
      .date(from: "2021-07-09T22:58:49Z")
    article.body = ""
    return article
  }
}
