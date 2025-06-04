//
//  MapView.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var initialPosition: MapCameraPosition
    
    var body: some View {
        Map(position: $initialPosition) {
            
        }
        .mapControls {
            MapPitchToggle()
            MapCompass()
            MapScaleView()
        }
        .mapStyle(.standard(elevation: .realistic))
    }
}

#Preview {
    MapView(initialPosition: .constant(.region(.init(center: .init(latitude: -34.600621, longitude: -58.387721), latitudinalMeters: 50000, longitudinalMeters: 50000))))
}
