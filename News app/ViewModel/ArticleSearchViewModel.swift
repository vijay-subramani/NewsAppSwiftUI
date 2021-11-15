//
//  ArticleSearchViewModel.swift
//  News app
//
//  Created by Vijay on 13/11/21.
//

import Foundation

@MainActor
class ArticleSearchViewModel: ObservableObject
{
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery: String = ""
    @Published var history = [String]()
    
    static let shared = ArticleSearchViewModel()
    private let newsAPI = NewsAPI.shared
    private let historyMaxLimit = 10
    private let searchHistoryStore = PlistDataStore<[String]>(filename: "searchHistory")
    
    private init() {
        Task.init(priority: .background, operation: {
            await load()
        })
    }
    
    
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count-1)
        }
        history.insert(text, at: 0)
        historyUpdated()
    }
    
    func removeHistory(_ text: String) {
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else {
            return
        }
        history.remove(at: index)
        historyUpdated()
    }
    
    func removeAllHistory()
    {
        history.removeAll()
        historyUpdated()
    }
    
    
    func searchArticle() async {
        
        if Task.isCancelled { return }
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty { return }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            addHistory(searchQuery)
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }
    
    private func historyUpdated()
    {
        let history = self.history
        
        Task.init(priority: .background) {
            await searchHistoryStore.save(history)
        }
    }
    
    private func load() async
    {
        self.history = await searchHistoryStore.load() ?? []
    }
    
}
