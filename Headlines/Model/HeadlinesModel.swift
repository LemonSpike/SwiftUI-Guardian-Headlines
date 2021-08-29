//
//  HeadlinesService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Combine
import Foundation

final class HeadlinesModel: ObservableObject {
  @Published(initialValue: []) var allArticles: [Article]
  @Published var error: HeadlinesError?

  var favouritedArticles: [Article] {
    allArticles.filter { $0.isFavourite }
  }

  var numberOfArticles: Int {
    allArticles.count
  }

  var numberOfFavouritedArticles: Int {
    favouritedArticles.count
  }

  var currentArticle: Article? {
    guard allArticles.indices.contains(currentIndex) else {
      return nil
    }
    return allArticles[currentIndex]
  }

  @Published(initialValue: 0) var currentIndex
  var task: AnyCancellable?
  let services: HeadlineServices
  init(services: HeadlineServices) {
    self.services = services
  }

  func persistAllArticles() {
    services.storageService.persistAllArticlesToStorage(allArticles, {
      [weak self] error in
      DispatchQueue.main.async { self?.error = error }
    })
  }
}

extension HeadlinesModel: StorageServiceDelegate { }
