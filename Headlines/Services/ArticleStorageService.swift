//
//  ArticleStorageService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//


import Foundation
import SwiftUI
import RealmSwift

protocol StorageService: AnyObject {
  var allArticles: [Article] { get }

  func retrieveAllArticlesFromStorage()
  func toggleArticleIsFavouritedInStorage(_ article: Article)
  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion:
                                    @escaping (HeadlinesError?) -> Void)
}

final class ArticleStorageService: StorageService {
  var allArticles: [Article]
  init(allArticles: [Article] = []) {
    self.allArticles = allArticles
  }

  func retrieveAllArticlesFromStorage() {
    guard allArticles.isEmpty else {
      return
    }
    DispatchQueue.global().sync {
      guard let realm = try? Realm() else { return }
      allArticles = Array(realm.objects(Article.self))
    }
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion:
                                    @escaping (HeadlinesError?) -> Void) {
    DispatchQueue.global().sync {
      guard let realm = try? Realm() else {
        completion(.realmInstanceCreationFailed)
        return
      }
      do {
        try realm.write {
          realm.deleteAll()
          realm.add(articles)
        }
        completion(nil)
      } catch let error {
        completion(.articlePersistenceFailed(error: error))
      }
    }
  }

  func toggleArticleIsFavouritedInStorage(_ article: Article) {
    DispatchQueue.global().sync {
      guard let realm = try? Realm() else {
        return
      }
      try? realm.write {
        article.isFavourite = !article.isFavourite
      }
    }
  }
}
