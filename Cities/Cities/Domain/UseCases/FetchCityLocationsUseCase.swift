//
//  FetchCityLocationsUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

final class FetchCityLocationsUseCase: FetchCityLocationsUseCaseProtocol {
    private let repository: CityRepositoryProtocol
    
    init(repository: CityRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws(CustomError) -> [CityLocation] {
        try await repository.fetchCitiesLocation().map { $0.toDomainModel() }
    }
}
