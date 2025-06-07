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
        }
        .background(.mint)
    }
}

#Preview {
    MapView(viewData: .constant(.init(position: .region(.init(center: .init(latitude: -34.600621, longitude: -58.387721), span: .init())), currentCityName: "Mock City", cities: [.mock, .mock, .mock, .mock, .mock, .mock, .mock])))
}
