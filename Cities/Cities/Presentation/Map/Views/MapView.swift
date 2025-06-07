//
//  MapView.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var viewData: MapViewData
    var displayCitySelector: Bool = true
    
    var body: some View {
        VStack {
            Map(position: $viewData.position) {
                if let region = viewData.position.region {
                    Annotation(viewData.currentCityName, coordinate: region.center ,anchor: .bottom) {
                        Image(systemName: "mappin.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(.red.gradient, in: .circle)
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
            
            if !viewData.cities.isEmpty, displayCitySelector {
                buildCitySelector()
            }
        }
        .background(.mint)
    }
    
    @ViewBuilder
    private func buildCitySelector() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(viewData.cities) { city in
                    Button {
                        
                    } label: {
                        Text(city.title)
                            .font(.body.weight(.medium))
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.white)
                    .background(Color.black)
                    .clipShape(.capsule)
                    .padding(.horizontal, 8)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0)
                            .scaleEffect(phase.isIdentity ? 1 : 0.75)
                            .blur(radius: phase.isIdentity ? 0 : 0.5)
                    }
                }
            }
        }
        .padding(.top, 16)
        .scrollIndicators(.hidden)
        .frame(height: 48)
        .background(.mint)
    }
}

#Preview {
    MapView(viewData: .constant(.init(position: .region(.init(center: .init(latitude: -34.600621, longitude: -58.387721), span: .init())), currentCityName: "Mock City", cities: [.mock, .mock, .mock, .mock, .mock, .mock, .mock])))
}
