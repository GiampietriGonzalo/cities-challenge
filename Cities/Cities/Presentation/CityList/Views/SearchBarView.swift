//
//  SearchBarView.swift
//  Cities
//
//  Created by Gonza Giampietri on 13/06/2025.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var showCancelButton: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: Strings.CitList.icons.search)
                    .renderingMode(.template)
                    .padding(.vertical, 4)
                    .padding(.leading, 8)
                TextField(Strings.CitList.searchPlaceholder, text: $searchText, onEditingChanged: { editing in
                    withAnimation {
                        showCancelButton = editing
                    }
                })
                .textFieldStyle(.plain)
                .padding(.vertical, 4)
                .autocorrectionDisabled()
            }
            .frame(height: 32)
            .background(Color.gray.opacity(0.1))
            .foregroundStyle(.secondary)
            .cornerRadius(8)
            .padding(.leading, 24)
            .padding(.trailing, !showCancelButton ? 24 : 8)
            
            if showCancelButton {
                Button {
                    searchText = ""
                } label: {
                    Text(Strings.CitList.cancelButtonText)
                }
                .padding(.trailing, 16)
                .transition(.scale)
            }
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    @Previewable @State var showCancelButton: Bool = false
    
    SearchBarView(searchText: $searchText, showCancelButton: $showCancelButton)
}
