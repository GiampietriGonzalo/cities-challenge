//
//  FavoriteRepositoryProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

protocol FavoriteRepositoryProtocol {
    /**
     * Insert a new  favortie Item into the storage
     * - Parameters:
     *    - cityId: integer value of the city to add as a favorite item
     * - Throws: A **CustomError** if something went wrong
     */
    func insertFavorite(cityId: Int) throws(CustomError)
    
    /**
     * Returns the ids of those items that are favorites
     * - Returns: An array of  Int with thd ids of those items that are favorites
     * - Throws: A **CustomError** if something went wrong
     */
    func fetchFavorites() throws(CustomError) -> [Int]
}
