//
//  HeadlinesError.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation

enum HeadlinesError: Error {
  case urlConstructionFailed
  case networkRequestError(error: Error?)
  case noDataReceived
  case unexpectedJsonFormat
  case emptyPayload
  case unknown(error: Error?)
  case articlePersistenceFailed(error: Error)
  case realmInstanceCreationFailed
}
