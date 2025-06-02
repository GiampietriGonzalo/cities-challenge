//
//  CityCellView.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import SwiftUI

struct CityCellView: View {
    
    let city: CityLocation
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(city.country + ", " + city.name)
                        .font(.title)
                        Spacer()
                }
                HStack {
                    Text("latitude:  \(city.coordinate.latitude.description)")
                    Text("longitude:  \(city.coordinate.longitude.description)")
                    Spacer()
                }
                .font(.caption2)
            }
            .padding(.leading, 16)
            
            Button {
            } label: {
                Text("See Details")
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
