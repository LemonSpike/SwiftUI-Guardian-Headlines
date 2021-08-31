//
//  FavouritesCell.swift
//  Headlines
//
//  Created by Pranav Kasetti on 31/08/2021.
//

import SwiftUI

struct FavouritesCell: View {

  @ObservedObject var model: HeadlinesModel
  @Binding var isDisplayed: Bool
  let article: ArticleReader

  var body: some View {
    HStack(spacing: 10) {
      if let data = article.imageData(), let image = UIImage(data: data) {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(minWidth: 0, maxWidth: 100,
                 minHeight: 0, maxHeight: 100, alignment: .center)
      }
      Spacer()
      VStack(spacing: 10) {
        Text(article.headline)
          .font(.headline)
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          .padding(.top)
        if let published = article.published {
          Text(published)
            .font(.caption)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
        }
      }
      Spacer()
      Image(systemName: Constants.articleStarFillIconName)
        .foregroundColor(.accentColor)
        .highPriorityGesture(
          TapGesture().onEnded { _ in
            model.didDeselectFavouritedArticle(article: article)
          }
        )
        .accessibility(identifier: Constants.articleStarFillIconId)
    }
    .onTapGesture {
      model.didSelectFavouritedArticle(article: article)
      isDisplayed = false
    }
  }
}

#if DEBUG
struct FavouritesCell_Previews: PreviewProvider {
  static var model: HeadlinesModel = {
    let services = HeadlineServices.mock
    var model = HeadlinesModel(services: services)
    services.setDelegate(delegate: model, nil)
    return model
  }()

  @State static var isDisplayed = true

  static var previews: some View {
    FavouritesCell(model: model,
                   isDisplayed: $isDisplayed,
                   article: ArticleReader(article: MockArticle.articleOne))
      .previewDevice(PreviewDevice(rawValue: "iPhone 12 Mini"))
  }
}
#endif
