//
//  SafariView.swift
//  News app
//
//  Created by Vijay on 12/11/21.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable
{
    let url: URL
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
