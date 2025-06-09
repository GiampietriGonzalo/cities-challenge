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

//{
//    "title": "Bahía Blanca",
//    "originalimage": {
//        "source": "https://upload.wikimedia.org/wikipedia/commons/4/47/Vistas_de_Bahia_Blanca_%2824%29.jpg",
//    },
//    "description": "City in Buenos Aires Province, Argentina",
//    "description_source": "local",
//    "coordinates": {
//        "lat": -38.71666667,
//        "lon": -62.26666667
//    },
//    "extract": "Bahía Blanca, colloquially referred to by its own local inhabitants as simply Bahía, is a city in the Buenos Aires province of Argentina, centered on the northwestern end of the eponymous Blanca Bay of the Argentine Sea. It is 4th largest city in the province, and the 16th largest in the country by metropolitan population. It is the seat of government of the Bahía Blanca Partido, with 336,574 inhabitants according to the 2022 census [INDEC]. Bahía Blanca is the principal city in the Greater Bahía Blanca metropolitan area.",
//}
