//
//  ArticlesView.swift
//  Headlines
//
//  Created by Pranav Kasetti on 27/08/2021.
//

import SwiftUI

struct ArticlesView: View {

  @ObservedObject var headlinesService = HeadlinesService()

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading, spacing: 10) {
        ZStack(alignment: .bottom) {
          Image(uiImage: UIImage(data: headlinesService
                                  .currentArticle.imageData)!)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
          Text(headlinesService.currentArticle.headline)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
        }
        Text(headlinesService.currentArticle.body)
          .font(.body)
          .foregroundColor(.black)
          .lineSpacing(1)
      }.padding()
    }
  }
}

struct ArticlesView_Previews: PreviewProvider {
  static var previews: some View {
    ArticlesView()
  }
}
