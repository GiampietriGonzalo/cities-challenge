//
//  SortCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

protocol SortCitiesUseCaseProtocol {
    func execute(cities: [CityLocation]) -> [CityLocation]
}
