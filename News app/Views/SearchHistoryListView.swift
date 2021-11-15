//
//  SearchHistoryListView.swift
//  News app
//
//  Created by Vijay on 14/11/21.
//

import SwiftUI

struct SearchHistoryListView: View {
    
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubmit: (String) -> ()
    
    var body: some View {
        List{
            HStack{
                Text("Search history")
                Spacer()
                Button("Clear") {
                    searchVM.removeAllHistory()
                }.foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            
            ForEach(searchVM.history, id: \.self) {history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions {
                    HStack{
                        Button(role: .destructive) {
                            searchVM.removeHistory(history)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            searchVM.searchQuery = history
                            Task.init(priority: .background, operation: {
                                await searchVM.searchArticle()
                            })
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                        }

                    }.lineSpacing(10)
                    
                    
                    

                }
            }
            
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(searchVM: ArticleSearchViewModel.shared){ _ in
            
        }
    }
}
