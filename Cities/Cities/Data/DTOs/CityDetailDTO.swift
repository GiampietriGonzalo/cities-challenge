//
//  CityDetailDTO.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

struct CityDetailDTO: Decodable {
    let title: String
    let description: String
    let extract: String
    let originalimage: ImageDTO
    let coordinates: CoordinateDTO

    struct ImageDTO: Decodable {
        let source: String
    }

    func toDomainModel(with countryCode: String) -> CityDetail {
        CityDetail(title: title,
                   countryCode: countryCode,
                   description: description,
                   extract: extract,
                   image: originalimage.source,
                   coordinates: .init(latitude: coordinates.lat, longitude: coordinates.lon))
    }
}
