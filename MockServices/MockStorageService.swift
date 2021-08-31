//
//  MockStorageService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

final class MockStorageDelegate: StorageServiceDelegate {
  let services: HeadlineServices
  var allArticles: [Article] = []
  var fetchedFromNetwork: Bool = false

  init(services: HeadlineServices = .mock) {
    self.services = services
  }
  func fetchArticles(_ completion: (() -> Void)?) {
    fetchedFromNetwork = true
    completion?()
  }
}

final class MockStorageService: StorageService {
  weak var delegate: StorageServiceDelegate?
  var retrievedFromStorage = false
  var firstTime = true

  func retrieveAllArticlesFromStorage() {
    if firstTime {
      delegate?.allArticles = []
      firstTime = false
    } else {
      delegate?.allArticles.append(contentsOf: [MockArticle.articleOne,
                                                MockArticle.articleTwo])
      retrievedFromStorage = true
    }
  }

  func toggleArticleIsFavouritedInStorage(_ article: inout Article,
                                          _ completion: ((HeadlinesError?) -> Void)?) {
    article.isFavourite.toggle()
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion: ((HeadlinesError?) -> Void)?) {
    delegate?.allArticles = articles
    completion?(nil)
  }
}
