//
//  CityLocation.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

struct CityLocation: Identifiable {
    let id: Int
    let name: String
    let country: String
    let coordinate: Coordinate

    struct Coordinate: Decodable {
        let latitude: Double
        let longitude: Double
    }
}
