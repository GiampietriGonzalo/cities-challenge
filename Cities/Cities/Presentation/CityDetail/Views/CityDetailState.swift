//
//  CityDetailState.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

/**
 *  An enumeration with all possible states of the CityDetail screen
 */
enum CityDetailState {
    case loading
    case loaded(viewData: CityDetailViewData)
    case onError(error: CustomError)
}
