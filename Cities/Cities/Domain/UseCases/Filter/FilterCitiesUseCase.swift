//
//  FilterCitiesUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FilterCitiesUseCase: FilterCitiesUseCaseProtocol {
    private var results: [String: [CityLocation]] = [:]
    
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] {
        guard let storedResults = results[text] else {
            let filteredCities = cities.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) })
            results[text] = filteredCities
            return filteredCities
        }
        
        return storedResults
    }
}
