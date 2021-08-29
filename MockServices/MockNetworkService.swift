//
//  MockNetworkService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation
import Combine

final class MockNetworkService: NetworkService {
  func fetchData(with request: URLRequest,
                 handler: @escaping (Data?, URLResponse?, Error?)
                  -> Void) -> AnyCancellable {
    guard let method = request.httpMethod, let url = request.url else {
      handler(nil, nil, URLError(.badURL))
      return AnyCancellable {}
    }
    let contentURL = "https://content.guardianapis.com/" +
    "search?q=finance&show-fields=main,body" +
    "&api-key=\(Constants.APIKey)"

    switch "\(method) \(url.absoluteString)" {
      case "GET \(contentURL)":
        handler(mockFixture(moduleFor: Self.self,
                            name: "two_headline_stub.json"),
                .successResponse(url),
                nil)
        break
      default: handler(nil, .notFoundResponse(url), URLError(.fileDoesNotExist))
    }

    return AnyCancellable {}
  }
}

private extension URLResponse {
  static func successResponse(_ url: URL) -> URLResponse {
    HTTPURLResponse(url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil)!
  }

  static func notFoundResponse(_ url: URL) -> URLResponse {
    HTTPURLResponse(url: url,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil)!
  }
}
