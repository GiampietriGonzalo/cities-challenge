//
//  FetchCityLocationsUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Foundation

/**
 *  Fetchs the city list
 * - Returns: An array of FilmModel with the information fetched
 * - Throws: An error if something goes wrong
 */
protocol FetchCityLocationsUseCaseProtocol {
    func execute() async throws(CustomError) -> [CityLocation]
}
