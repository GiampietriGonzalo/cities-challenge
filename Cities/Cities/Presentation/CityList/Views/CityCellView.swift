//
//  CityCellView.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import SwiftUI
import SwiftData

struct CityCellView: View {
    
    let viewData: CityLocationViewData
    @Query var favorites: [FavoriteCity]
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(viewData.title)
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Text(viewData.subtitle)
                    Spacer()
                }
                .font(.caption2)
            }
            .padding(.leading, 16)
            .foregroundStyle(.black)
            
            Button {
            } label: {
                Text(viewData.detailButtonText)
                    .font(.headline)
                    .frame(minHeight: 28)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.white)
            .background(Color.black)
            .clipShape(.capsule)
            .padding(.trailing, 8)
            
            Image(systemName: (favorites.first(where: { $0.id == viewData.id })?.isFavorite ?? false) ? "star.fill" : "star")
                .resizable()
                .frame(width: 24, height: 24)
                .tint(.yellow)
                .padding(.trailing, 16)
                .highPriorityGesture(TapGesture().onEnded {
                    if let index = favorites.firstIndex(where: { $0.id == viewData.id }) {
                        favorites[index].isFavorite.toggle()
                    } else {
                        viewData.onFavoriteSelected()
                    }
                })
        }
        .padding(.vertical, 16)
        .background {
            LinearGradient(gradient: Gradient(colors: [.mint.opacity(0.7), .mint.opacity(0.85)]),
                           startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    CityCellView(viewData: .mock)
}
