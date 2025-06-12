//
//  CityDetailDTO+Mock.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

extension CityDetailDTO {
    static var mock = CityDetailDTO(title: "Bahía Blanca",
                                    description: "City in Buenos Aires Province, Argentina",
                                    extract: "",
                                    originalimage: .init(source: "https://upload.wikimedia.org/wikipedia/commons/4/47/Vistas_de_Bahia_Blanca_%2824%29.jpg"),
                                    coordinates: .init(lat: -38.716, lon: -62.266))
}
