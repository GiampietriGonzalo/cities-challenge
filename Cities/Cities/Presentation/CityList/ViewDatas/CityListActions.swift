//
//  CityListActions.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

enum CityListAction {
    case select(id: Int, orientationIsLandscape: Bool)
    case tapFavorite(id: Int)
    case seeDetail(id: Int)
}
