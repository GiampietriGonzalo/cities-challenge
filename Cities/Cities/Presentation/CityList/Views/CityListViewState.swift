//
//  CityListViewState.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

enum CityListViewState {
    case loading
    case loaded([CityLocationViewData])
    case onError(CustomError)
}
