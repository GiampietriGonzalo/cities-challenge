//
//  FilterCitiesUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

protocol FilterCitiesUseCaseProtocol {
    
    /**
     * Set up the filter with a given array of CityLocationViewData
     * - Parameters:
     *    - cities: An array of CityLocationViewData to configure the filter
     */
    func setup(with cities: [CityLocationViewData])
    
    /**
     * Filter a given array of CityLocationViewData by a given text value
     * - Parameters:
     *    - cities: An array of CityLocationViewData to configure the filter
     *    - text: An String value to filter the cities array
     */
    func execute(cities: [CityLocationViewData], filterBy text: String) -> [CityLocationViewData]
}
