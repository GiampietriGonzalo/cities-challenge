//
//  CityLocation+Mock.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

extension CityLocation {
    static let mock = CityLocation(
        id: 1,
        name: "Mock City",
        country: "AR",
        coordinate: .init(latitude: -34.600621, longitude: -58.387721)
    )
    
    static let mockA = CityLocation(
        id: 2,
        name: "A",
        country: "AR",
        coordinate: .init(latitude: -12.123123, longitude: -12.123123)
    )
    
    static let mockB = CityLocation(
        id: 3,
        name: "B",
        country: "AR",
        coordinate: .init(latitude: -34.6234, longitude: -34.6234)
    )
    
    static let mockZ = CityLocation(
        id: 3,
        name: "Z",
        country: "AR",
        coordinate: .init(latitude: -23.232, longitude: -23.232)
    )
}
