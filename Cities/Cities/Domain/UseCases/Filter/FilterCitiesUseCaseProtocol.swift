//
//  FilterCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

protocol FilterCitiesUseCaseProtocol {
    func setup(with cities: [CityLocationViewData])
    func execute(cities: [CityLocationViewData], filterBy text: String) -> [CityLocationViewData]
}
