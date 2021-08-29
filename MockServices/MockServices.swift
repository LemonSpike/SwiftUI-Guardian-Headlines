//
//  MockServices.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

extension HeadlineServices {
  static var mock: HeadlineServices {
    return .init(networkService: MockNetworkService(),
                 storageService: MockStorageService())
  }
}
