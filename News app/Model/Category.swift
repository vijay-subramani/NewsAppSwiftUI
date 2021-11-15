//
//  Category.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import Foundation

enum Category: String, CaseIterable
{
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
