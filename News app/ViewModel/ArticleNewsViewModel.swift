//
//  ArticleNewsViewModel.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import SwiftUI


enum DataFetchPhase<T>
{
    case empty
    case success(T)
    case failure(Error)
}

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject
{
    @Published var phase = DataFetchPhase<[Article]>.empty
//    @Published var selectedCategory: Category
    @Published var fetchTaskToken: FetchTaskToken
    private let newsAPI = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general)
    {
        if let articles = articles {
            phase = .success(articles)
        }else
        {
            phase = .empty
        }
        
//        self.selectedCategory = selectedCategory
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    func loadArticles() async
    {
//        phase = .success(Article.previewData)
        if Task.isCancelled { return }
        phase = .empty
        do {
//            let articles = try await newsAPI.fetch(from: selectedCategory)
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
