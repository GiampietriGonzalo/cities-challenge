//
//  TestList.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

import SwiftUI

struct TestList: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
            .listStyle(.plain)
            .searchable(text: .constant(""), placement: .automatic, prompt: "Search")
            .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    TestList()
}
