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
    var currentCityName: String
    let cities: [CityLocation]
    
    static let empty = MapViewData(position: .region(.init(center: .init(), span: .init())), currentCityName: CityLocation.mock.name,
                                   cities: [.mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock])
}
