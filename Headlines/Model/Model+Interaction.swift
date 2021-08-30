//
//  ArticleDisplayingService.swift
//  Headlines
//
//  Created by Pranav Kasetti on 28/08/2021.
//

import Foundation

// MARK: ArticleSwipeInteraction
private protocol ArticleInteraction {
  func didSwipeArticleRight()
  func didSwipeArticleLeft()
  func toggleFavourite()
}

// MARK: ArticleSelection
private protocol ArticleSelection {
  func didSelectFavouritedArticle(atIndex index: Int)
  func didDeselectFavouritedArticle(atIndex index: Int)
}

// MARK: Handle interactions.
extension HeadlinesModel: ArticleInteraction {
  func didSwipeArticleRight() {
    guard currentIndex != 0, allArticles.indices.contains(currentIndex) else {
      return
    }
    currentIndex -= 1
  }

  func didSwipeArticleLeft() {
    guard currentIndex != allArticles.indices.last,
          allArticles.indices.contains(currentIndex) else { return }
    currentIndex += 1
  }

  func toggleFavourite() {
    guard allArticles.indices.contains(currentIndex) else { return }
    services.storageService
      .toggleArticleIsFavouritedInStorage(&allArticles[currentIndex], nil)
  }
}

// MARK: Handle Favourites View cell selection.
extension HeadlinesModel: ArticleSelection {
  func didSelectFavouritedArticle(atIndex index: Int) {
    guard favouritedArticles.indices.contains(index) else { return }
    guard let index = allArticles
            .firstIndex(of: favouritedArticles[index]) else { return }
    currentIndex = index
  }

  func didDeselectFavouritedArticle(atIndex index: Int) {
    guard favouritedArticles.indices.contains(index) else { return }
    guard let index = allArticles
            .firstIndex(of: favouritedArticles[index]) else { return }
    services.storageService
      .toggleArticleIsFavouritedInStorage(&allArticles[index], nil)
  }
}
