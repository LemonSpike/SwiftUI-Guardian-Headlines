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
  var delegate: StorageServiceDelegate? { get set }

  func retrieveAllArticlesFromStorage()
  func toggleArticleIsFavouritedInStorage(_ article: inout Article)
  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion:
                                    @escaping (HeadlinesError?) -> Void)
}

protocol StorageServiceDelegate: AnyObject {
  var allArticles: [Article] { get set }
  func fetchArticles()
}

final class ArticleStorageService: StorageService {
  weak var delegate: StorageServiceDelegate?

  func retrieveAllArticlesFromStorage() {
    guard let delegate = delegate, delegate.allArticles.isEmpty else {
      return
    }
    DispatchQueue.global().sync {
      guard let realm = try? Realm() else { return }
      delegate.allArticles = Array(realm.objects(Article.self))
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

  func toggleArticleIsFavouritedInStorage(_ article: inout Article) {
    DispatchQueue.global().sync {
      guard let realm = try? Realm() else {
        return
      }
      try? realm.write {
        article.isFavourite.toggle()
      }
    }
  }
}
