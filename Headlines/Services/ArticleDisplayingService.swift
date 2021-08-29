//
//  ArticleDisplayingService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Foundation

// MARK: ArticleSwipeInteraction
private protocol ArticleSwipeInteraction {
  mutating func didSwipeArticleRight()
  mutating func didSwipeArticleLeft()
}

// MARK: ArticleSelection
private protocol ArticleSelection {
  mutating func didSelectFavouritedArticle(atIndex index: Int)
}

// MARK: ArticleDisplayingService
struct ArticleDisplayingService {

  var allArticles: [Article]
  private var favouritedArticles: [Article] {
    return allArticles.filter { $0.isFavourite }
  }
  private var currentIndex = 0

  var articleToDisplay: Article? {
    guard allArticles.indices.contains(currentIndex) else {
      return nil
    }
    return allArticles[currentIndex]
  }

  init(_ allArticles: [Article] = []) {
    self.allArticles = allArticles
  }
}

// MARK: Handle interactions.
extension ArticleDisplayingService: ArticleSwipeInteraction {
  mutating func didSwipeArticleRight() {
    guard currentIndex != 0, allArticles.indices.contains(currentIndex) else {
      return
    }
    currentIndex -= 1
  }

  mutating func didSwipeArticleLeft() {
    guard currentIndex != allArticles.indices.last,
          allArticles.indices.contains(currentIndex) else { return }
    currentIndex += 1
  }
}

// MARK: Handle Favourites View cell selection.
extension ArticleDisplayingService: ArticleSelection {
  mutating func didSelectFavouritedArticle(atIndex index: Int) {
    guard favouritedArticles.indices.contains(index) else { return }
    guard let index = allArticles
            .firstIndex(of: favouritedArticles[index]) else { return }
    currentIndex = index
  }
}
