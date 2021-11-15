//
//  SearchTabView.swift
//  News app
//
//  Created by Vijay on 13/11/21.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) { suggetionsView }
        .onChange(of: searchVM.searchQuery, perform: { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        })
        .onSubmit(of: .search, search)
    }
    
    private var articles: [Article] {
        if case let .success(articles) = searchVM.phase {
            return articles
        }else
        {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View
    {
        switch searchVM.phase
        {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty{
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search news", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private var suggetionsView: some View {
        ForEach(["Swift", "Covid-19", "BTC", "PS5", "iOS 15"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    private func search()
    {
        
        let searchQuery = self.searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        Task.init(priority: .background, operation: {
            await searchVM.searchArticle()
        })
    }
    
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
