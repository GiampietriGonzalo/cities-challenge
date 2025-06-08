//
//  FilterCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

protocol FilterCitiesUseCaseProtocol {
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation]
}
