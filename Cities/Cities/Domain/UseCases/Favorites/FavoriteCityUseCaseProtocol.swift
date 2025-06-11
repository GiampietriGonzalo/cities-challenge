//
//  FavoriteCityUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

protocol FavoriteCityUseCaseProtocol {
    
    /**
     * Insert a new  favortie Item into the storage
     * - Parameters:
     *    - cityId: integer value of the city to add as a favorite item
     * - Throws: A **CustomError** if something went wrong
     */
    func insert(cityId: Int) throws(CustomError)
}
