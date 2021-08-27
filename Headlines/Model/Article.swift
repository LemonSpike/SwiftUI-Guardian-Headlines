//
//  Article.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation
import RealmSwift

final class Article: Object, Decodable {
  @Persisted var headline: String = ""
  @Persisted var body: String = ""
  @Persisted var published: Date?
  @Persisted var isFavourite: Bool = false
  @Persisted dynamic var rawImageURL: String?

  var imageURL: URL? {
    guard let rawImageURL = rawImageURL else { return nil }
    return URL(string: rawImageURL)
  }

  private enum CodingKeys: String, CodingKey {
    case headline = "webTitle"
    case published = "webPublicationDate"
    case fields
    case body
    case main
  }

  private enum FieldCodingKeys: String, CodingKey {
    case body
    case main
  }

  convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.headline = try container.decode(String.self,
                                         forKey: .headline)
    let pubString = try container.decodeIfPresent(String.self,
                                                  forKey: .published)
    if let pubString = pubString {
      let formatter = ISO8601DateFormatter()
      self.published = formatter.date(from: pubString)
    }

    let fields = try container.nestedContainer(keyedBy: FieldCodingKeys.self,
                                               forKey: .fields)

    let fullBody = try fields.decode(String.self, forKey: .body)
    self.body = fullBody.strippingTags

    let fullMain = try fields.decode(String.self,
                                     forKey: .main)
    self.rawImageURL = fullMain.url?.absoluteString
  }
}
