//
//  Services+Init.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Foundation
import RealmSwift

extension HeadlineServices {
  convenience init() {
    self.init(networkService: URLSession.shared,
              storageService: ArticleStorageService())
  }
}
