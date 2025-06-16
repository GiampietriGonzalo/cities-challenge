//
//  SortCitiesAlphabeticallyUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class SortCitiesAlphabeticallyUseCase: SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation] {
        var citiesDictionary: [Int: CityLocation] = [:]
        var citiesWithNameThatStartWithLetter: [CityLocation?] = []
        var citiesWithNameThatDoesNotStartWithLetter: [CityLocation?] = []
        
        var textsDictionary: [Int: String] = [:]
        
        cities.forEach {
            let text = ($0.name + $0.country).removeWithespaces().lowercased()
            textsDictionary[$0.id] = text
            citiesDictionary[$0.id] = $0
        }
        
        let sortedsTextsDictionary = textsDictionary.sorted { $0.value < $1.value }
        
        for entry in sortedsTextsDictionary {
            if entry.value.first?.isLetter ?? false {
                citiesWithNameThatStartWithLetter.append(citiesDictionary[entry.key])
            } else {
                citiesWithNameThatDoesNotStartWithLetter.append(citiesDictionary[entry.key])
            }
        }
        
        citiesWithNameThatStartWithLetter.append(contentsOf: citiesWithNameThatDoesNotStartWithLetter)
        return citiesWithNameThatStartWithLetter.compactMap { $0 }
    }
}
