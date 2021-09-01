//
//  HeadlinesApp.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import SwiftUI

@main
struct HeadlinesApp: App {
  @StateObject var model: HeadlinesModel = {
    let services = HeadlineServices()
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model, model.fetchCompletionHandler)
    return model
  }()

  var body: some Scene {
    WindowGroup {
      ArticlesContainerView(model: model)
    }
  }
}
