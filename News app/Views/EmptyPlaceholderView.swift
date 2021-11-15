//
//  EmptyPlaceholderView.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import SwiftUI

struct EmptyPlaceholderView: View
{
    let text: String
    let image: Image?
    
    var body: some View {
        VStack
        {
            Spacer()
            if let image = image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }
    }
    
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No bookmarks", image:Image(systemName: "bookmark"))
    }
}
