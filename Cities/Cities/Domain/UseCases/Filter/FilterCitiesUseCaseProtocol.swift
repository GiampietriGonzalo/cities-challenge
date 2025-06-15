//
//  FilterCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

protocol FilterCitiesUseCaseProtocol {
    
    /**
     * Set up the filter with a given array of CityLocation
     * - Parameters:
     *    - cities: An array of CityLocation to configure the filter
     */
    func setup(with cities: [CityLocation])
    
    /**
     * Filter a given array of CityLocation by a given text value
     * - Parameters:
     *    - cities: An array of CityLocation to configure the filter
     *    - text: An String value to filter the cities array
     */
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation]
}
