//
//  FavoriteRepositoryProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

protocol FavoriteRepositoryProtocol {
    func insertFavorite(cityId: Int) throws(CustomError)
    func isFavorite(cityId: Int) throws(CustomError) -> Bool
}
