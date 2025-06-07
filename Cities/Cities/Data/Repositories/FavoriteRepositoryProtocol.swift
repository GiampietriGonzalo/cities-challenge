//
//  FavoriteRepositoryProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

protocol FavoriteRepositoryProtocol {
    func toggleFavorite(cityId: Int) throws(CustomError)
    func isFavorite(cityId: Int) throws(CustomError) -> Bool
}
