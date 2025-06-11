//
//  SortCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 11/06/2025.
//

protocol SortCitiesUseCaseProtocol {
    
    /**
     * Sort a given array of cities and returns the result
     * - Parameters:
     *    - cities: An array of CityLocation models to sort
     * - Returns: A sorted array of CityLocation models
     */
    func execute(cities: [CityLocation]) -> [CityLocation]
}
