//
//  MockStorageService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

final class MockStorageService: StorageService {
  var allArticles: [Article] = [MockArticle.articleOne]

  func retrieveAllArticlesFromStorage() { }

  func toggleArticleIsFavouritedInStorage(_ article: Article) {
    let changer = allArticles.first { candidate in
      candidate.headline == article.headline
    }
    changer?.isFavourite.toggle()
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion:
                                    @escaping (HeadlinesError?) -> Void) {
    allArticles = articles
  }
}
