//
//  FilterCitiesUseCaseMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

@testable import Cities

final class FilterCitiesUseCaseMock: FilterCitiesUseCaseProtocol {
    func setup(with cities: [CityLocation]) {}
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] { cities }
}
