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
          .alert(isPresented: $model.showOnboardingAlert) {
            Alert(title: Text(Strings.appTitle),
                  message: Text(Strings.onBoardingMessage),
                  dismissButton: Alert.Button.default(Text("Ok")))
          }
      } else {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
          .alert(isPresented: $model.showErrorAlert) {
            Alert(title: Text(Strings.errorAlertTitle),
                  message: Text(Strings.errorAlertMessage),
                  dismissButton: Alert.Button
                    .default(Text(Strings.errorAlertOk))
            )
          }
      }
    }
    .preferredColorScheme(.dark)
    .toolbar(content: {
      ToolbarItemGroup(placement: .bottomBar) {
        if model.currentArticle?.isFavourite == true {
          Image(systemName: Constants.articleStarFillIconName)
            .foregroundColor(.accentColor)
            .onTapGesture {
              model.toggleFavourite()
            }
            .accessibility(identifier: Constants.articleStarFillIconId)
        } else {
          Image(systemName: Constants.articleStarIconName)
            .foregroundColor(.accentColor)
            .onTapGesture {
              model.toggleFavourite()
            }
            .accessibility(identifier: Constants.articleStarIconId)
        }
        Spacer()
        Button(Strings.favourites) {
          presentingFavourites.toggle()
        }.font(.title2)
        .foregroundColor(.accentColor)
      }
    })
    .fullScreenCover(isPresented: $presentingFavourites) {
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
        .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
      ArticlesContainerView(model: model)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
  }
}
#endif
