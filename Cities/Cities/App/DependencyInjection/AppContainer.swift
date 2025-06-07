//
//  AppContainer.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftData

final class AppContainer {
    
    static let shared = AppContainer()
    let coordinator = CityListViewCoordinatorViewModel()
    var modelContext: ModelContext?

    private init() {}

    func buildCityListViewModel() -> CityListViewModelProtocol {
        let networkClient = NetworkRestClient()
        let repository = CityRepository(networkClient: networkClient)
        let fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        let mapLocationToCameraPositionUseCase = MapLocationToCameraPositionUseCase()
        let viewModel = CityListViewModel(coordinator: coordinator,
                                          fetchCityListUseCase: fetchCityListUseCase,
                                          mapLocationToCameraPositionUseCase: mapLocationToCameraPositionUseCase)
        
        return viewModel
    }
    
    func buildMapViewModel(viewData: MapViewData) -> MapViewModelProtocol {
        MapViewModel(viewData: viewData)
    }
}
