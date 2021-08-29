//
//  URLSession+NetworkService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Combine
import Foundation

protocol NetworkService {
  func fetchData(with: URLRequest,
                 handler: @escaping (Data?,
                                     URLResponse?,
                                     Error?) -> Void) -> AnyCancellable
}

extension URLSessionDataTask: Cancellable {}

extension URLSession: NetworkService {
  func fetchData(with request: URLRequest,
                 handler: @escaping (Data?,
                                     URLResponse?,
                                     Error?) -> Void) -> AnyCancellable {
    let task = dataTask(with: request, completionHandler: handler)
    task.resume()
    return AnyCancellable(task)
  }
}
