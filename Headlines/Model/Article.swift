//
//  Article.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation
import Combine
import RealmSwift

final class Article: Object {
  @Persisted var headline: String = ""
  @Persisted var body: String = ""
  @Persisted var published: Date?
  @Persisted var isFavourite: Bool = false
  @Persisted dynamic var rawImageURL: String?

  // If I had more time, I would have injected this dependency for SwiftUI
  // Previews to load images and for best practice.
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
    task = networkService.fetchData(with: req) { data, response, error in
      dataReceived = data
      group.leave()
    }
    _ = group.wait(timeout: .now().advanced(by: .seconds(10)))
    return dataReceived
  }
}
