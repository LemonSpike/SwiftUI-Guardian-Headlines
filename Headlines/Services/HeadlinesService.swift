//
//  HeadlinesService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import SwiftUI

final class HeadlinesService: ObservableObject {
  @Published var allArticles: [Article] = []
}
