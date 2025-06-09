//
//  CityLocation.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

struct CityLocation: Identifiable, Equatable {
    let id: Int
    let name: String
    let country: String
    let coordinate: Coordinate

    static func == (lhs: CityLocation, rhs: CityLocation) -> Bool {
        lhs.id == rhs.id
    }
}
