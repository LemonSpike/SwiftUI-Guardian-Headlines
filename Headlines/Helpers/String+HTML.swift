//
//  String+Extension.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation

extension String {
  var strippingTags: String {
    var result = self
      .replacingOccurrences(of: "</p> <p>", with: "\n\n") as NSString

    var range = result.range(of: "<[^>]+>", options: .regularExpression)
    while range.location != NSNotFound {
      result = result.replacingCharacters(in: range, with: "") as NSString
      range = result.range(of: "<[^>]+>", options: .regularExpression)
    }

    return result as String
  }

  var url: URL? {
    let checkingType = NSTextCheckingResult.CheckingType.link.rawValue
    guard let detector =
            try? NSDataDetector(types: checkingType) else { return nil }
    let matches = detector.matches(in: self,
                                   options: [],
                                   range: NSRange(location: 0,
                                                  length: (self as NSString)
                                                    .length))
    return matches.first?.url
  }
}
