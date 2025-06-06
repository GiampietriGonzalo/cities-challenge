//
//  CityListViewData.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

struct CityListViewData: Equatable {
    let cityLocations: [CityLocationViewData]
    let mapViewData: MapViewData?
    var actions: [String] = []

    struct Actions {
        let onSelectCity: (CityLocation) -> Void
        let onMapNavigation: (CityLocation) -> Void
    }
}
