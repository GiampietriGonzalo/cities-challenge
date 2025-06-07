//
//  MapViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import MapKit

struct MapViewData: Equatable {
    var position: MapCameraPosition
    var currentCityName: String
    let cities: [CityLocationViewData]
    
    static let empty = MapViewData(position: .region(.init(center: .init(), span: .init())), currentCityName: CityLocation.mock.name,
                                   cities: [.mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock])
    
    static func == (lhs: MapViewData, rhs: MapViewData) -> Bool {
        lhs.position == rhs.position && lhs.currentCityName == rhs.currentCityName && lhs.cities == rhs.cities
    }
}
