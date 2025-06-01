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
    func fetchCitiesLocation() async throws -> [CityLocationDTO]
    
    /**
     *  Fetchs the city information
     * - Parameter url: The endpoint to fetch the information
     * - Returns: A CityDTO with the information
     * - Throws: An error if something goes wrong
     */
    func fetchCityDetail(id: Int) async throws -> CityDTO
}
