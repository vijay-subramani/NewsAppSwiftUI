//
//  NewsAPI.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import Foundation

struct NewsAPI
{
    static let shared = NewsAPI()
    private init() {}
    
    
    private let apiKey = "8619ac86b42d45beb26985e11d0922ab"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article]
    {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    func search(for query: String) async throws -> [Article]
    {
        try await fetchArticles(from: generateSearchURL(for: query))
    }
    
    private func fetchArticles(from url: URL) async throws -> [Article]
    {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(code: -1, description: "Bad Response")
        }
        
        switch response.statusCode
        {
        case (200...299),(400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok"
            {
                return apiResponse.articles ?? []
            }else{
                throw generateError(code: -1, description: apiResponse.message ?? "An error occured ")
            }
            
        default:
            throw generateError(code: -1, description: "A server error occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error
    {
        return NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func generateSearchURL(for query: String) -> URL {
        
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    private func generateNewsURL(from category: Category) -> URL
    {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
    
}
