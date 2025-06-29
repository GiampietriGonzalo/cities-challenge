//
//  ErrorViews.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

import SwiftUI

struct ServiceErrorView: View {
    let message: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        ContentUnavailableView {
            Label(Strings.Errors.serviceError, systemImage: "icloud.slash")
        } description: {
            VStack {
                Text(message)
                if let action {
                    Button(Strings.Errors.retryButtonText) {
                        action()
                    }
                }
            }
        }
    }
}

struct NoResultsErrorView: View {
    let message: String
    
    var body: some View {
        ContentUnavailableView.search(text: message)
    }
}

#Preview {
    ServiceErrorView(message: "Something went wrong with our provider", action: {})
    NoResultsErrorView(message: "searchedtext")
}
