//
//  ContentView.swift
//  News app
//
//  Created by Vijay on 11/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        ArticleListView(articles: Article.previewData)
        TabView
        {
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            SearchTabView()
                .tabItem{
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
