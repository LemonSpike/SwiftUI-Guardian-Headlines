//
//  MockNetworkService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation
import Combine

final class MockNetworkService: NetworkService {
  var fetchDataCalled = false

  func fetchData(with request: URLRequest,
                 handler: @escaping (Data?, URLResponse?, Error?)
                  -> Void) -> AnyCancellable {
    fetchDataCalled = true
    guard let method = request.httpMethod, let url = request.url else {
      handler(nil, nil, URLError(.badURL))
      return AnyCancellable {}
    }
    let contentURL = "https://content.guardianapis.com/" +
    "search?q=finance&show-fields=main,body" +
    "&api-key=\(Constants.APIKey)"

    let headlineOneImg = "https://media.guim.co.uk/" +
      "e1526d226af53c8ed55d50fda12e8ba0776c5328/0_123_3500_2101/1000.jpg"

    let headlineTwoImg = "https://media.guim.co.uk/" +
      "75ed9fabe90eb6495a12780a1e7683b6a42b8a2c/0_0_3500_2100/1000.jpg"

    switch "\(method) \(url.absoluteString)" {
    case "GET \(contentURL)":
      handler(mockFixture(moduleFor: Self.self,
                          name: "two_headline_stub.json"),
              .successResponse(url),
              nil)
    case "GET \(headlineOneImg)":
      handler(mockFixture(moduleFor: Self.self,
                          name: "headline_one_img.jpg"),
              .successResponse(url),
              nil)
    case "GET \(headlineTwoImg)":
      handler(mockFixture(moduleFor: Self.self,
                          name: "headline_two_img.jpg"),
              .successResponse(url),
              nil)
    default:
      handler(nil, .notFoundResponse(url), URLError(.fileDoesNotExist))
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
