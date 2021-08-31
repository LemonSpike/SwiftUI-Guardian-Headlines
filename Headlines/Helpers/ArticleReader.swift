//
//  ArticleReader.swift
//  Headlines
//
//  Created by Pranav Kasetti on 31/08/2021.
//

import Foundation
import Combine

final class ArticleReader: Identifiable {
  let article: Article
  let networkService: NetworkService
  private var task: AnyCancellable?

  init(article: Article, networkService: NetworkService = URLSession.shared) {
    self.article = article
    self.networkService = networkService
  }

  var id: UUID {
    realmQueue.sync {
      article.id
    }
  }

  var headline: String {
    realmQueue.sync {
      article.headline
    }
  }

  var body: String {
    realmQueue.sync {
      article.body
    }
  }

  var isFavourite: Bool {
    realmQueue.sync {
      article.isFavourite
    }
  }

  var published: String? {
    realmQueue.sync {
      if let published = article.published {
        return DateFormatter.headlines.string(from: published)
      } else {
        return nil
      }
    }
  }
}

// MARK: Networking
extension ArticleReader {
  var imageURL: URL? {
    var rawImageURL: String?
    realmQueue.sync {
      rawImageURL = article.rawImageURL
    }
    if let rawImageURL = rawImageURL {
      return URL(string: rawImageURL)
    } else {
      return nil
    }
  }

  func imageData() -> Data? {
    guard let url = imageURL else { return nil }
    let group = DispatchGroup()
    group.enter()
    let req = URLRequest(url: url)
    var dataReceived: Data?
    task = networkService.fetchData(with: req) { data, _, _ in
      dataReceived = data
      group.leave()
    }
    _ = group.wait(timeout: .now().advanced(by: .seconds(10)))
    return dataReceived
  }
}
