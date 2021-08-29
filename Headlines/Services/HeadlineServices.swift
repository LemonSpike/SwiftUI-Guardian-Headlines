//
//  HeadlineServices.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Combine
import Foundation

final class HeadlineServices {

  let networkService: NetworkService
  let storageService: StorageService

  init(networkService: NetworkService,
       storageService: StorageService) {
    self.networkService = networkService
    self.storageService = storageService
  }

  func setDelegate(delegate: StorageServiceDelegate?,
                   _ completion: (() -> Void)?) {
    storageService.delegate = delegate
    delegate?.fetchArticles(completion)
  }
}
