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
    self.allArticles.filter({ $0.isFavourite })
  }

  var numberOfArticles: Int {
    self.allArticles.count
  }

  var numberOfFavouritedArticles: Int {
    self.favouritedArticles.count
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
  init(services: HeadlineServices)
  {
    self.services = services
    self.fetchArticles()
  }

  func persistAllArticles() {
    self.services.storageService.persistAllArticlesToStorage(self.allArticles, {
      [weak self] error in
      DispatchQueue.main.async { self?.error = error }
    })
  }
}
