//
//  CityListViewState.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

enum CityListViewState: Equatable {
    case loading
    case loaded([CityLocationViewData], MapViewData?)
    case onError(CustomError)
}
