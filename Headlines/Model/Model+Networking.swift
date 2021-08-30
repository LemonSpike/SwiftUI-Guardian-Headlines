//
//  Model+Networking.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

extension HeadlinesModel {
  func fetchArticles(_ completion: (() -> Void)?) {
    if allArticles.isEmpty {
      services.storageService.retrieveAllArticlesFromStorage()
    }
    guard allArticles.isEmpty else {
      completion?()
      return
    }
    guard let completeURL = constructArticlesURLWithQueryParams(
      baseURL: URLs.articleBaseURL
    ) else {
      error = HeadlinesError.urlConstructionFailed
      completion?()
      return
    }
    DispatchQueue.global().async { [weak self] in
      self?.makeArticlesRequest(completeURL, completion)
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

  private func makeArticlesRequest(_ completeURL: URL,
                                   _ completion: (() -> Void)?) {
    let request = URLRequest(url: completeURL)
    task = services.networkService.fetchData(with: request) { [weak self] data, response, error in
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
          self?.cacheAllArticles(response.articles, completion)
        }
      } catch let error as HeadlinesError {
        DispatchQueue.main.async {
          self?.error = error
          completion?()
        }
      } catch {
        DispatchQueue.main.async {
          self?.error = HeadlinesError.unknown(error: error)
          completion?()
        }
      }
    }
  }

  private func cacheAllArticles(_ articles: [Article],
                                _ completion: (() -> Void)?) {
    articles.forEach { [weak self] article in
      let modelNetwork = self?.services.networkService
      article.networkService = modelNetwork ?? URLSession.shared
    }
    allArticles = articles
    persistAllArticles(completion)
  }
}
