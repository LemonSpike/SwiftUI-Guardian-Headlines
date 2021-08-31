//
//  ArticlesView.swift
//  Headlines
//
//  Created by Pranav Kasetti on 31/08/2021.
//

import SwiftUI

struct ArticlesView: View {

  @ObservedObject var model: HeadlinesModel

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading) {
        ZStack(alignment: .bottom) {
          if let data = model
              .currentArticle?.imageData(), let image = UIImage(data: data) {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .accessibility(identifier: Constants.articleImageId)
          }
          Text(model.currentArticle?.headline ?? "")
            .font(.title)
            .foregroundColor(.white)
            .padding()
        }
        Text(model.currentArticle?.body ?? "")
          .font(.body)
          .foregroundColor(.primary)
          .lineSpacing(1)
          .padding(EdgeInsets(top: 18, leading: 18, bottom: 50, trailing: 18))
          .accessibility(identifier: Constants.articleBodyId)
      }.frame(minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading)
      .padding()
      .gesture(
        DragGesture(coordinateSpace: .local)
          .onEnded { gesture in
            let translation = gesture.translation
            if translation.width > 20 {
              model.didSwipeArticleRight()
            } else if translation.width < -20 {
              model.didSwipeArticleLeft()
            }
          }
      )
    }
    .alert(isPresented: $model.showAlert) {
      Alert(title: Text("An error occurred"),
            message: Text("Please try again later."),
            dismissButton: Alert.Button.default(Text("Ok"))
      )
    }
    .animation(.spring())
    .navigationTitle("Headlines 🗞")
    .navigationViewStyle(DoubleColumnNavigationViewStyle())
  }
}

// This macros is to exclude previews from UI test code coverage reports.
#if DEBUG
struct ArticlesView_Previews: PreviewProvider {
  static var model: HeadlinesModel = {
    let services = HeadlineServices.mock
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model, nil)
    return model
  }()

  static var previews: some View {
    Group {
      ArticlesView(model: model)
        .colorScheme(.light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
      ArticlesView(model: model)
        .colorScheme(.dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
  }
}
#endif
