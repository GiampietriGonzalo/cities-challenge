//
//  FavoriteRepositoryMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FavoriteRepositoryMock: FavoriteRepositoryProtocol {
    
    private var favoriteCities: [FavoriteCity] = []
    
    func insertFavorite(cityId: Int) throws(CustomError) {
        favoriteCities.append(.init(id: cityId))
    }
    
    func isFavorite(cityId: Int) throws(CustomError) -> Bool {
        favoriteCities.first(where: { $0.id == cityId })?.isFavorite ?? false
    }
}
