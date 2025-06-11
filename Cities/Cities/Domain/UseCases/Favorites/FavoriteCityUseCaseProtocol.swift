//
//  FavoriteCityUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 07/06/2025.
//

protocol FavoriteCityUseCaseProtocol {
    func insert(cityId: Int) throws(CustomError)
}
