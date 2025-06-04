//
//  MapViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import Observation

@Observable
final class MapViewModel: MapViewModelProtocol {
    
    private let cities: [CityLocation]
    var viewData: MapViewData = .empty
    
    init(cities: [CityLocation]) {
        self.cities = cities
        
        if let firstCity = cities.first {
//            viewData = .init(initalPosition: firstCity, cities: cities)
        }
    }
}
    
