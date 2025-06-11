//
//  FilterCitiesUseCaseMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

final class FilterCitiesUseCaseMock: FilterCitiesUseCaseProtocol {
    func setup(with cities: [CityLocationViewData]) {}
    func execute(cities: [CityLocationViewData], filterBy text: String) -> [CityLocationViewData] { cities }
}
