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

let realmQueue = DispatchQueue(label: "headlines.serial.queue")

final class ArticleStorageService: StorageService {

  private var realm: Realm?
  private var realmStorageQueue: DispatchQueue

  init(realm: Realm?, realmStorageQueue: DispatchQueue = realmQueue) {
    self.realmStorageQueue = realmStorageQueue
    realmQueue.sync {
      self.realm = realm
    }
  }

  weak var delegate: StorageServiceDelegate?

  func retrieveAllArticlesFromStorage() {
    guard let delegate = delegate, delegate.allArticles.isEmpty else {
      return
    }
    var realmObjects: [Article] = []
    realmStorageQueue.sync { [weak self] in
      guard let realm = self?.realm else { return }
      realmObjects = Array(realm.objects(Article.self))
    }
    delegate.allArticles = realmObjects
  }

  func persistAllArticlesToStorage(_ articles: [Article],
                                   _ completion: ((HeadlinesError?) -> Void)?) {
    realmStorageQueue.sync { [weak self] in
      guard let realm = self?.realm else {
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
    realmStorageQueue.sync { [weak self, article] in
      guard let realm = self?.realm else {
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
