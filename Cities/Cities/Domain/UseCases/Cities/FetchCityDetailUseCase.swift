//
//  FetchCityDetailUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

final class FetchCityDetailUseCase: FetchCityDetailUseCaseProtocol {
    
    private let repository: CityRepositoryProtocol
    
    init(repository: CityRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String, countryCode: String) async throws(CustomError) -> CityDetail {
        let nameParam = name.folding(options: .diacriticInsensitive, locale: .current)
        return try await repository.fetchCityDetail(nameParam: nameParam).toDomainModel(with: countryCode)
    }
}
