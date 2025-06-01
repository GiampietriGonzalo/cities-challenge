//
//  CityLocationDTO.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation

struct CityLocationDTO: Decodable {
    let id: Int
    let name: String
    let country: String
    let coordinate: Coordinate

    struct Coordinate: Decodable {
        let lat: Double
        let lon: Double
    }
    
    func toDomainModel() -> CityLocation {
        return CityLocation(id: id,
                            name: name,
                            country: country,
                            coordinate: .init(latitude: coordinate.lat, longitude: coordinate.lon))
    }
}
