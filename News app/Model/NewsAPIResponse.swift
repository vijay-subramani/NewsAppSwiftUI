//
//  NewsAPIResponse.swift
//  News app
//
//  Created by Vijay on 11/11/21.
//

import Foundation

struct NewsAPIResponse: Decodable
{
    //success state
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    //error state
    let code: String?
    let error: String?
    let message: String?
}
