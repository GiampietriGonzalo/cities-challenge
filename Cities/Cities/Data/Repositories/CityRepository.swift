//
//  CityRepository.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Foundation

final class CityRepository: CityRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchCitiesLocation() async throws(CustomError) -> [CityLocationDTO] {
        guard let url = EndpointBuilder.build(for: .cities) else {
            throw CustomError.invalidUrl("Cities urls is not valid")
        }
        
        return try await networkClient.fetch(from: url)
    }
    
    func fetchCityDetail(nameParam: String) async throws(CustomError) -> CityDetailDTO {
        
        guard !nameParam.isEmpty else {
            throw CustomError.serviceError("City name is empty")
        }
        
        guard let url = EndpointBuilder.build(for: .detail(name: nameParam)) else {
            throw CustomError.invalidUrl("City detail url is not valid")
        }
       
        return try await networkClient.fetch(from: url)
    }
}
