//
//  DateFormatter+Headlines.swift
//  Headlines
//
//  Created by Pranav Kasetti on 31/08/2021.
//

import Foundation

extension DateFormatter {
  static let headlines: DateFormatter = {
    let format = DateFormatter()
    format.dateStyle = .medium
    return format
  }()
}
