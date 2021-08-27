//
//  HeadlineResponse.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import Foundation

final class HeadlineResponse: Decodable {

  private enum CodingKeys: String, CodingKey {
    case response
  }

  private enum NestedCodingKeys: String, CodingKey {
    case results
  }

  let articles: [Article]

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let response = try container.nestedContainer(keyedBy: NestedCodingKeys.self,
                                                 forKey: .response)
    self.articles = try response.decode([Article].self,
                                        forKey: .results)
  }
}
