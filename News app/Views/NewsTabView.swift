//
//  NewsTabView.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    
    var body: some View {
        NavigationView
        {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
                /*
                 .task(id: articleNewsVM.selectedCategory, loadTask)
                 .refreshable {
                    loadTask()
                }
                .onAppear{
                    loadTask()
                }
                .onChange(of: articleNewsVM.selectedCategory, perform: { newValue in
                    loadTask()
                })
               .navigationTitle(articleNewsVM.selectedCategory.text)*/
        }
    }
    
    @ViewBuilder
    private var overlayView: some View
    {
        switch articleNewsVM.phase {
        case .empty: ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error): RetryView(text: error.localizedDescription) {
            //TODO: Refresh the news API
//            loadTask()
            refreshTask()
        }
            
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase
        {
            return articles
        }else
        {
            return []
        }
    }
    
    private var menu: some View
    {
        Menu{
//            Picker("Category", selection: $articleNewsVM.selectedCategory){
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category){ 
                ForEach(Category.allCases){
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
        }
    }
    ///This load task method is rewritten in the below to get handled through Task
    /*private func loadTask()
    {
        //Task.init(priority: TaskPriority.high, operation: {
        // await articleNewsVM.loadArticles()
        //})
        async {
            await articleNewsVM.loadArticles()
        }
    }*/
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    @Sendable
    private func refreshTask()
    {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }

}

struct NewsTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
