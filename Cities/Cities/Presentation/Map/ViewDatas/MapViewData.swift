//
//  MapViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import MapKit

struct MapViewData {
    var position: MapCameraPosition
    let cities: [CityLocation]
    
    static let empty = MapViewData(position: .region(.init(center: .init(latitude: -34.600621, longitude: -58.387721), latitudinalMeters: 50000, longitudinalMeters: 50000)), cities: [.mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock])
}
