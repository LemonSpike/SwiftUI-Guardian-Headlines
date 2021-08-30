//
//  Article.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation
import Combine
import RealmSwift

final class Article: Object, Identifiable {
  @Persisted var id = UUID()
  @Persisted var headline: String = ""
  @Persisted var body: String = ""
  @Persisted var published: Date?
  @Persisted var isFavourite: Bool = false
  @Persisted dynamic var rawImageURL: String?

  var networkService: NetworkService = URLSession.shared
  private var task: AnyCancellable?

  var imageURL: URL? {
    guard let rawImageURL = rawImageURL else { return nil }
    return URL(string: rawImageURL)
  }

  var imageData: Data? {
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
