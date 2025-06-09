//
//  CityDetailState.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

enum CityDetailState {
    case loading
    case loaded(viewData: CityDetailViewData)
    case onError(error: CustomError)
}
