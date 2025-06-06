//
//  MapViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import Observation
import SwiftUI
import MapKit

@Observable
final class MapViewModel: MapViewModelProtocol {
    
    var viewData: MapViewData
    
    init(viewData: MapViewData) {
        self.viewData = viewData
//        self.cities = cities
//        
//        if let firstCity = cities.first {
//            viewData = .init(position: mapLocationToCameraPosition(location: firstCity), currentCityName: firstCity.name, cities: cities)
//        }
    }
    
    private func mapLocationToCameraPosition(location: CityLocation) -> MapCameraPosition {
        MapCameraPosition.region(.init(center: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                       latitudinalMeters: 50000, longitudinalMeters: 50000))
    }
}
    
