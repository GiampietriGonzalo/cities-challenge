//
//  FetchCityDetailUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

/**
 *  Fetchs the detail information of a city
 * - Parameters cityId: An Int id value related to a city
 * - Returns: A City entity
 * - Throws: An error if something goes wrong
 */
protocol FetchCityDetailUseCaseProtocol {
    func execute(cityId: Int) async throws -> City
}
