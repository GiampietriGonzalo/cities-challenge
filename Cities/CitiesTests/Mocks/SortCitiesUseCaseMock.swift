//
//  SortCitiesUseCaseMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

@testable import Cities

final class SortCitiesUseCaseMock: SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation] {
        cities
    }
}
