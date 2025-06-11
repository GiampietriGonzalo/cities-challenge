//
//  FetchCityLocationsUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation

/**
 *  Fetchs the city list
 * - Returns: An array of CityLocation models with the information fetched
 * - Throws: A **CustomError** if something goes wrong
 */
protocol FetchCityLocationsUseCaseProtocol {
    func execute() async throws(CustomError) -> [CityLocation]
}
