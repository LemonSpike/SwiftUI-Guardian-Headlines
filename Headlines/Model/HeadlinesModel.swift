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
  var error: HeadlinesError? {
    didSet {
      showErrorAlert = (error != nil)
    }
  }

  @Published var showErrorAlert = false

  @Published var showOnboardingAlert = false

  var favouritedArticles: [ArticleReader] {
    allArticles
      .map { ArticleReader(article: $0,
                           networkService: services.networkService) }
      .filter { $0.isFavourite }
  }

  var numberOfArticles: Int {
    allArticles.count
  }

  var numberOfFavouritedArticles: Int {
    favouritedArticles.count
  }

  var currentArticle: ArticleReader? {
    guard allArticles.indices.contains(currentIndex) else {
      return nil
    }
    return ArticleReader(article: allArticles[currentIndex],
                         networkService: services.networkService)
  }

  @Published(initialValue: 0) var currentIndex
  var task: AnyCancellable?
  let services: HeadlineServices
  init(services: HeadlineServices) {
    self.services = services
  }

  func persistAllArticles(_ completion: (() -> Void)?) {
    services.storageService.persistAllArticlesToStorage(allArticles, { [weak self] error in
      DispatchQueue.main.async {
        self?.error = error
        completion?()
      }
    })
  }
}

extension HeadlinesModel: StorageServiceDelegate { }
