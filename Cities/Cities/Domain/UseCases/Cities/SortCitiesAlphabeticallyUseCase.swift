//
//  SortCitiesAlphabeticallyUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class SortCitiesAlphabeticallyUseCase: SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation] {
        let sortedCities = cities.sorted { $0.name < $1.name }
        
        var citiesWithNameThatStartWithLetter: [CityLocation] = []
        var citiesWithNameThatDoesNotStartWithLetter: [CityLocation] = []
        
        for city in sortedCities {
            if city.name.first?.isLetter ?? false {
                citiesWithNameThatStartWithLetter.append(city)
            } else {
                citiesWithNameThatDoesNotStartWithLetter.append(city)
            }
        }
        
        return citiesWithNameThatStartWithLetter + citiesWithNameThatDoesNotStartWithLetter
    }
}
