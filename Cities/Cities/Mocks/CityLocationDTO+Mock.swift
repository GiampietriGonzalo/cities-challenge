//
//  CityLocationDTO+Mock.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

extension CityLocationDTO {
    static var mock = CityLocationDTO(_id: 1,
                                      name: "Mock",
                                      country: "Ar",
                                      coord: .init(lat: 123, lon: 123))
}
