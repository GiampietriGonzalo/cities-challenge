//
//  CityListViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Combine

struct CityListViewData: Equatable {
    let cityLocations: [CityLocationViewData]
    let mapViewData: MapViewData?
    let onFilterPublisher: PassthroughSubject<String, Never>
    
    static func == (lhs: CityListViewData, rhs: CityListViewData) -> Bool {
        lhs.cityLocations == rhs.cityLocations && lhs.mapViewData == rhs.mapViewData
    }
}
