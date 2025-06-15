//
//  FilterCitiesUseCaseMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class FilterCitiesUseCaseMock: FilterCitiesUseCaseProtocol {
    func setup(with cities: [CityLocation]) {}
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] { cities }
}
