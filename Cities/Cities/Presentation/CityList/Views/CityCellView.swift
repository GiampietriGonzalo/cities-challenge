//
//  CityCellView.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import SwiftUI

struct CityCellView: View {
    
    let city: CityLocationViewData
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(city.title)
                        .font(.title3)
                        Spacer()
                }
                HStack {
                    Text(city.subtitle)
                    Spacer()
                }
                .font(.caption2)
            }
            .padding(.leading, 16)
            .foregroundStyle(.black)
            
            Button {
            } label: {
                Text(city.detailButtonText)
                    .font(.headline)
                    .frame(minHeight: 28)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.white)
            .background(Color.black)
            .clipShape(.capsule)
            .padding(.trailing, 8)
            
            Button {
            } label: {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(.yellow)
            }
            .padding(.trailing, 16)
            
        }
        .padding(.vertical, 16)
        .background {
            LinearGradient(gradient: Gradient(colors: [.mint.opacity(0.7), .mint.opacity(0.85)]),
                           startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    CityCellView(city: .mock)
}
