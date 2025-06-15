//
//  FavoriteRepositoryMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FavoriteRepositoryMock: FavoriteRepositoryProtocol {
    var favoriteCities: [FavoriteCity] = []
    var error: CustomError?
    
    func insertFavorite(cityId: Int) throws(CustomError) {
        if let error = error {
            throw error
        } else {
            favoriteCities.append(.init(id: cityId))
        }
    }
    
    func fetchFavorites() throws(CustomError) -> [Int] {
        favoriteCities.map(\.id)
    }
}
