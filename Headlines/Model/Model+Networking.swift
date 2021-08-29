//
//  Model+Networking.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

extension HeadlinesModel {
  func fetchArticles() {
    if allArticles.isEmpty {
      services.storageService.retrieveAllArticlesFromStorage()
    }
    guard allArticles.isEmpty else { return }
    guard let completeURL = constructArticlesURLWithQueryParams(
      baseURL: URLs.articleBaseURL
    ) else {
      error = HeadlinesError.urlConstructionFailed
      return
    }
    DispatchQueue.global().async { [weak self] in
      self?.makeArticlesRequest(completeURL)
    }
  }

  private func makeArticlesRequest(_ completeURL: URL) {
    let request = URLRequest(url: completeURL)
    task = services.networkService.fetchData(with: request) { [weak self]
      data, response, error in
      do {
        if let error = error {
          throw HeadlinesError.networkRequestError(error: error)
        }

        guard let data = data else {
          throw HeadlinesError.noDataReceived
        }

        guard let response = try? JSONDecoder().decode(HeadlinesResponse.self,
                                                       from: data) else {
          throw HeadlinesError.unexpectedJsonFormat
        }

        if response.articles.isEmpty {
          throw HeadlinesError.emptyPayload
        }

        DispatchQueue.main.async {
          self?.allArticles = response.articles
          self?.persistAllArticles()
        }
      } catch let error as HeadlinesError {
        DispatchQueue.main.async { self?.error = error }
      } catch {
        DispatchQueue.main.async {
          self?.error = HeadlinesError.unknown(error: error)
        }
      }
    }
  }

  private func constructArticlesURLWithQueryParams(baseURL: String,
                                                   path: String =
                                                    URLs.articleSearchPath,
                                                   query: String = "finance",
                                                   showFields: String =
                                                    "main,body",
                                                   apiKey: String = Constants
                                                    .APIKey
  ) -> URL? {
    let queryItems = [URLQueryItem(name: URLs.articleQueryParam,
                                   value: query),
                      URLQueryItem(name: URLs.articleShowFieldsParam,
                                   value: showFields),
                      URLQueryItem(name: URLs.articleAPIKeyParam,
                                   value: apiKey)]
    var urlComponents = URLComponents(string: baseURL)
    urlComponents?.queryItems = queryItems
    urlComponents?.path = path
    return urlComponents?.url
  }
}
