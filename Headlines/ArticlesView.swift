//
//  ArticlesView.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import SwiftUI

struct ArticlesView: View {

  @ObservedObject var model: HeadlinesModel

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading) {
        ZStack(alignment: .bottom) {
          if let data = model
              .currentArticle?.imageData, let image = UIImage(data: data) {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
          }
          Text(model.currentArticle?.headline ?? "")
            .font(.title)
            .foregroundColor(.white)
            .padding()
        }
        Text(model.currentArticle?.body ?? "")
          .font(.body)
          .foregroundColor(.black)
          .lineSpacing(1)
          .padding()
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
  }
}

struct ArticlesView_Previews: PreviewProvider {
  static var model: HeadlinesModel = {
    let services = HeadlineServices.mock
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model)
    return model
  }()

  static var previews: some View {
    Group {
      ArticlesView(model: model)
        .colorScheme(.light)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
      ArticlesView(model: model)
        .colorScheme(.dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
  }
}
