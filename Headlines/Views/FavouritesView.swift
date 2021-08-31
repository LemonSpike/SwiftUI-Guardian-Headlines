//
//  FavouritesView.swift
//  Headlines
//
//  Created by Pranav Kasetti on 30/08/2021.
//

import SwiftUI

struct FavouritesView: View {

  @ObservedObject var model: HeadlinesModel
  @Binding var isDisplayed: Bool

  var body: some View {
    NavigationView {
      let numFavs = model.numberOfFavouritedArticles
      List(model.favouritedArticles) { article in
        FavouritesCell(model: model,
                       isDisplayed: $isDisplayed,
                       article: article)
      }.listStyle(InsetGroupedListStyle())
      .navigationViewStyle(StackNavigationViewStyle())
      .toolbar(content: {
        Button(Strings.buttonDismiss) {
          isDisplayed = false
        }
      })
      .navigationBarTitle("\(numFavs) \(Strings.favouritesScreenTitle)")
      .preferredColorScheme(.dark)
    }
  }
}

// This macros is to exclude previews from UI test code coverage reports.
#if DEBUG
struct FavouritesView_Previews: PreviewProvider {
  static var model: HeadlinesModel = {
    let services = HeadlineServices.mock
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model, nil)
    return model
  }()

  @State static var isDisplayed = true

  static var previews: some View {
    Group {
      FavouritesView(model: model, isDisplayed: $isDisplayed)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
      FavouritesView(model: model, isDisplayed: $isDisplayed)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
  }
}
#endif
