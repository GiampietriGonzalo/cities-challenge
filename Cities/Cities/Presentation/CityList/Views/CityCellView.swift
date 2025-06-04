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
                        .font(.title2)
                        Spacer()
                }
                HStack {
                    Text(city.subtitle)
                    Spacer()
                }
                .font(.caption2)
            }
            .padding(.leading, 16)
            
            Button {
            } label: {
                Text(city.detailButtonText)
                    .font(.headline)
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.orange)
            .background(Color.black)
            .clipShape(.capsule)
            .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
        .background {
            LinearGradient(gradient: Gradient(colors: [.blue, .orange]),
                           startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    CityCellView(city: .mock)
}
