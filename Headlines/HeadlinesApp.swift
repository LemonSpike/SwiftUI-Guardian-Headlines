//
//  HeadlinesApp.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import SwiftUI

@main
struct HeadlinesApp: App {
  @StateObject var model = HeadlinesModel(services: HeadlineServices())
  var body: some Scene {
    WindowGroup {
      ArticlesView(model: model)
    }
  }
}
