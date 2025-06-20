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
    @Binding var isFilteringByFavorites: Bool
    @FocusState private var isSearchFieldFocused: Bool
    
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
                .focused($isSearchFieldFocused)
            }
            .frame(height: 32)
            .background(Color.gray.opacity(0.1))
            .foregroundStyle(.secondary)
            .cornerRadius(8)
            .padding(.leading, 16)
            .padding(.trailing, 8)
            
            if showCancelButton {
                Button {
                    searchText = ""
                    showCancelButton = false
                    isSearchFieldFocused = false
                } label: {
                    Text(Strings.CitList.cancelButtonText)
                }
                .padding(.trailing, 8)
                .transition(.scale)
            }
            
            Button {
                withAnimation {
                    isFilteringByFavorites.toggle()
                }            } label: {
                Image(systemName: isFilteringByFavorites ?  "heart.slash" : "heart.fill")
                    .resizable()
                    .tint(isFilteringByFavorites ? .black : .red)
                    .frame(width: 20, height: 20)
            }
            
            .padding(.trailing, 16)
            .transition(.opacity)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    @Previewable @State var showCancelButton: Bool = false
    @Previewable @State var isFilteringByFavorites: Bool = false
    
    SearchBarView(searchText: $searchText,
                  showCancelButton: $showCancelButton,
                  isFilteringByFavorites: $isFilteringByFavorites)
}
