//
//  CityListViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

struct CityListViewData: Equatable {
    let cityLocations: [CityLocationViewData]
    let mapViewData: MapViewData?
    let onFilter: @Sendable (String) -> Void
    
    static func == (lhs: CityListViewData, rhs: CityListViewData) -> Bool {
        lhs.cityLocations == rhs.cityLocations && lhs.mapViewData == rhs.mapViewData
    }
}
