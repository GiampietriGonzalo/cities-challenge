//
//  CityRepository.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Foundation

final class CityRepository: CityRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let citiesLocationEndpoint: String
    private let cityDetailEndpoint: String
    
    init(networkClient: NetworkClientProtocol,
         citiesLocationEndpoint: String = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json",
         cityDetailEnpoint: String = "") {
        self.networkClient = networkClient
        self.citiesLocationEndpoint = citiesLocationEndpoint
        self.cityDetailEndpoint = cityDetailEnpoint
    }
    
    func fetchCitiesLocation() async throws(CustomError) -> [CityLocationDTO] {
        guard let url = URL(string: citiesLocationEndpoint) else {
            throw CustomError.invalidUrl(citiesLocationEndpoint)
        }
        
        return try await networkClient.fetch(from: url)
    }
    
    func fetchCityDetail(id: Int) async throws(CustomError) -> CityDTO {
        guard let url = URL(string: cityDetailEndpoint) else {
            throw CustomError.invalidUrl(cityDetailEndpoint)
        }
        
        return try await networkClient.fetch(from: url)
    }
}
