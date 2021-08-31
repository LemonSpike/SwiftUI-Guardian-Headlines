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
  @Persisted var rawImageURL: String?
}
