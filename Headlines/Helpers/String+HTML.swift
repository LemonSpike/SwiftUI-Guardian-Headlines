//
//  String+Extension.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation

extension String {

  private enum Constants {
    static let paragraphTags = "</p> <p>"
    static let doubleLines = "\n\n"
    static let tagMatcher = "<[^>]+>"
    static let emptyString = ""
    static let startLocation = 0
  }

  var strippingTags: String {
    var result = self
      .replacingOccurrences(of: Constants.paragraphTags,
                            with: Constants.doubleLines) as NSString

    var range = result.range(of: Constants.tagMatcher,
                             options: .regularExpression)
    while range.location != NSNotFound {
      result = result
        .replacingCharacters(in: range,
                             with: Constants.emptyString) as NSString
      range = result.range(of: Constants.tagMatcher,
                           options: .regularExpression)
    }

    return result as String
  }

  var url: URL? {
    let checkingType = NSTextCheckingResult.CheckingType.link.rawValue
    guard let detector =
            try? NSDataDetector(types: checkingType) else { return nil }
    let matches = detector.matches(in: self,
                                   options: [],
                                   range: NSRange(location:
                                                    Constants.startLocation,
                                                  length: (self as NSString)
                                                    .length))
    return matches.first?.url
  }
}
