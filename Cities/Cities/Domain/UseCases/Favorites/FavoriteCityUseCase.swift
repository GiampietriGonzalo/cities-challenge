//
//  FavoriteCityUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

final class FavoriteCityUseCase: FavoriteCityUseCaseProtocol {
    private let repository: FavoriteRepositoryProtocol
    
    init(repository: FavoriteRepositoryProtocol) {
        self.repository = repository
    }
    
    func insert(cityId: Int) throws(CustomError) {
        try repository.insertFavorite(cityId: cityId)
    }
}
