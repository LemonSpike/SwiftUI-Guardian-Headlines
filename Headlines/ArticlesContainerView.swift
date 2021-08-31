//
//  ArticlesContainerView.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import SwiftUI

struct ArticlesContainerView: View {

  @ObservedObject var model: HeadlinesModel
  @State var presentingFavourites = false

  var body: some View {
    NavigationView {
      if (model.currentArticle != nil) {
        ArticlesView(model: model)
      } else {
        ProgressView()
      }
    }
    .toolbar(content: {
      ToolbarItemGroup(placement: .bottomBar) {
        if model.currentArticle?.isFavourite == true {
          Image(systemName: "star.fill")
            .foregroundColor(.accentColor)
            .onTapGesture {
              model.toggleFavourite()
            }
            .accessibility(identifier: Constants.articleStarFillIconId)
        } else {
          Image(systemName: "star")
            .foregroundColor(.accentColor)
            .onTapGesture {
              model.toggleFavourite()
            }
            .accessibility(identifier: Constants.articleStarIconId)
        }
        Spacer()
        Button("Favourites") {
          presentingFavourites.toggle()
        }.font(.title2)
        .foregroundColor(.accentColor)
      }
    })
    .sheet(isPresented: $presentingFavourites) {
      FavouritesView(model: model,
                     isDisplayed: $presentingFavourites)
    }
  }
}

// This macros is to exclude previews from UI test code coverage reports.
#if DEBUG
struct ArticlesContainerView_Previews: PreviewProvider {
  static var model: HeadlinesModel = {
    let services = HeadlineServices.mock
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model, nil)
    return model
  }()

  static var previews: some View {
    Group {
      ArticlesContainerView(model: model)
        .colorScheme(.light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
      ArticlesContainerView(model: model)
        .colorScheme(.dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
  }
}
#endif
