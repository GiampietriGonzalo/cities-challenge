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
                    .frame(height: 28)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.white)
            .background(Color.black)
            .clipShape(.capsule)
            .padding(.trailing, 16)
            
        }
        .padding(.vertical, 16)
        .background {
            Color.mint
//            LinearGradient(gradient: Gradient(colors: [.mint, .mint]),
//                           startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    CityCellView(city: .mock)
}
