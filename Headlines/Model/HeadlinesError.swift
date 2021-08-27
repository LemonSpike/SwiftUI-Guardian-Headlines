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
    case unexpectedJsonFormat
    case articlePersistenceFailed(error: Error)
    case realmInstanceCreationFailed
}
