//
//  SortCitiesAlphabeticallyUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class SortCitiesAlphabeticallyUseCase: SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation] {
        let sortedCities = cities.sorted { (city1, city2) in
            let city1Text = city1.name + city1.country
            let city2Text = city2.name + city2.country
            
            return city1Text.removeWithespaces().lowercased() < city2Text.removeWithespaces().lowercased()
        }
        
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
