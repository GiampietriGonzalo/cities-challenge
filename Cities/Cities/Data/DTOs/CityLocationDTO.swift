//
//  CityLocationDTO.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation

struct CityLocationDTO: Decodable {
    let _id: Int
    let name: String
    let country: String
    let coord: Coordinate

    struct Coordinate: Decodable {
        let lat: Double
        let lon: Double
    }
    
    func toDomainModel() -> CityLocation {
        return CityLocation(id: _id,
                            name: name,
                            country: country,
                            coordinate: .init(latitude: coord.lat, longitude: coord.lon))
    }
}
