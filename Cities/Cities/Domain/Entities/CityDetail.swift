//
//  CityDetail.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

struct CityDetail {
    let title: String
    let countryCode: String
    let description: String
    let extract: String
    let image: String
    let coordinates: Coordinate
    
    func mapToViewData() -> CityDetailViewData {
        CityDetailViewData(title: title,
                           subtitle: title + ", " + countryCode,
                           description: description,
                           extract: extract,
                           image: .init(string: image),
                           coordinates: coordinates)
    }
}
