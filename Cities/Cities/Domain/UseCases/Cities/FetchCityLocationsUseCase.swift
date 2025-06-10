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
        let cities = try await repository.fetchCitiesLocation().map { $0.toDomainModel() }.sorted { $0.name < $1.name }
        var nameStartWithLetter: [CityLocation] = []
        var nameDoesNotStartWithLetter: [CityLocation] = []
        
        for city in cities {
            if city.name.first?.isLetter ?? false {
                nameStartWithLetter.append(city)
            } else {
                nameDoesNotStartWithLetter.append(city)
            }
        }
        
        return nameStartWithLetter + nameDoesNotStartWithLetter
    }
}
