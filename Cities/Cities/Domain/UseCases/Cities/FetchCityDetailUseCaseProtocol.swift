//
//  FetchCityDetailUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

/**
 *  Fetchs the detail information of a city
 * - Parameters:
 *      - name: A city name
 *      - countryCode: The country code of a city
 * - Returns: a CityDetail model with the information of a city
 * - Throws: A **CustomError** if something goes wrong
 */
protocol FetchCityDetailUseCaseProtocol {
    func execute(name: String, countryCode: String) async throws(CustomError) -> CityDetail
}
