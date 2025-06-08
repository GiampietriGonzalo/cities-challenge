//
//  FilterCitiesUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FilterCitiesUseCase: FilterCitiesUseCaseProtocol {
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] {
        cities.filter({ $0.name.lowercased().hasPrefix(text.lowercased()) })
    }
}
