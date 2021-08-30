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
  func toggleArticleIsFavouritedInStorage(_ article: inout Article,
                                          _ completion:
                                            ((HeadlinesError?) -> Void)?)
  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion: ((HeadlinesError?) -> Void)?)
}

protocol StorageServiceDelegate: AnyObject {
  var allArticles: [Article] { get set }
  func fetchArticles(_ completion: (() -> Void)?)
}

final class ArticleStorageService: StorageService {

  private let realm: Realm?

  init(realm: Realm? = try? Realm()) {
    self.realm = realm
  }

  weak var delegate: StorageServiceDelegate?

  func retrieveAllArticlesFromStorage() {
    guard let delegate = delegate, delegate.allArticles.isEmpty else {
      return
    }
    DispatchQueue.global().sync {
      guard let realm = realm else { return }
      delegate.allArticles = Array(realm.objects(Article.self))
    }
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion: ((HeadlinesError?) -> Void)?) {
    DispatchQueue.global().sync {
      guard let realm = realm else {
        completion?(.realmInstanceCreationFailed)
        return
      }
      do {
        try realm.write {
          realm.deleteAll()
          realm.add(articles)
        }
        completion?(nil)
      } catch let error {
        completion?(.articlePersistenceFailed(error: error))
      }
    }
  }

  func toggleArticleIsFavouritedInStorage(_ article: inout Article,
                                          _ completion:
                                            ((HeadlinesError?) -> Void)? = nil)
  {
    DispatchQueue.global().sync {
      guard let realm = realm else {
        completion?(.realmInstanceCreationFailed)
        return
      }
      do {
        try realm.write {
          article.isFavourite.toggle()
          completion?(nil)
        }
      } catch {
        completion?(.articlePersistenceFailed(error: error))
      }
    }
  }
}
