//
//  FetchCityDetailUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

/**
 *  Fetchs the detail information of a city
 * - Parameters cityId: An Int id value related to a city
 * - Returns: A City name
 * - Throws: An error if something goes wrong
 */
protocol FetchCityDetailUseCaseProtocol {
    func execute(name: String, countryCode: String) async throws(CustomError) -> CityDetail
}
