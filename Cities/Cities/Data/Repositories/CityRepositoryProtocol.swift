//
//  CityRepositoryProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation

protocol CityRepositoryProtocol {
    
    /**
     *  Fetchs the city locations
     * - Parameter url: The endpoint to fetch the list
     * - Returns: A CityLocationDTO with the information
     * - Throws: An error if something goes wrong
     */
    func fetchCitiesLocation() async throws(CustomError) -> [CityLocationDTO]
    
    /**
     *  Fetchs the city information
     * - Parameter nameParam: The name useful to fetch the information
     * - Returns: A CityDetailDTO with the information
     * - Throws: An error if something goes wrong
     */
    func fetchCityDetail(nameParam: String) async throws(CustomError) -> CityDetailDTO
}
