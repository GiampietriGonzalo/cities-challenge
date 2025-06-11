//
//  SortCitiesUseCaseMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class SortCitiesUseCaseMock: SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation] {
        cities
    }
}
