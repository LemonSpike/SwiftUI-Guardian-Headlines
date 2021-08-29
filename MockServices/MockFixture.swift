//
//  MockFixture.swift
//  Headlines
//
//  Created by Pranav Kasetti on 29/08/2021.
//

import Foundation

func mockFixture(moduleFor type: AnyObject.Type,
                 name: String) -> Data {
  guard
    let mockFixturesURL = Bundle(for: type).url(forResource: name, withExtension: nil),
    let data = try? Data(contentsOf: mockFixturesURL)
  else {
    fatalError("Mock fixture \(name) not found.")
  }
  return data
}
