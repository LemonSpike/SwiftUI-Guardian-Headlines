//
//  MockStorageService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

final class MockStorageDelegate: StorageServiceDelegate {
  var allArticles: [Article] = [MockArticle.articleOne]
  func fetchArticles() { }
}

final class MockStorageService: StorageService {
  var delegate: StorageServiceDelegate? = MockStorageDelegate()

  func retrieveAllArticlesFromStorage() { }

  func toggleArticleIsFavouritedInStorage(_ article: Article) {
    let changer = delegate?.allArticles.first { candidate in
      candidate.headline == article.headline
    }
    changer?.isFavourite.toggle()
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion:
                                    @escaping (HeadlinesError?) -> Void) {
    delegate?.allArticles = articles
  }
}
