//
//  CityListPushNavigationType.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import Foundation

enum CityListPushNavigationType: PushNavigationType {
    var id: UUID { UUID() }
   
    case list
    case detail(city: String)
    case map(coordinates: CityLocation.Coordinate)
}

extension CityListPushNavigationType: Hashable {
    static func == (lhs: CityListPushNavigationType, rhs: CityListPushNavigationType) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
