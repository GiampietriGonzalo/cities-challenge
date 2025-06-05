//
//  AppContainer.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

final class AppContainer {
    
    static let shared = AppContainer()
    let coordinator = CityListViewCoordinatorViewModel()

    private init() {}

    func buildCityListViewModel() -> CityListViewModelProtocol {
        let networkClient = NetworkRestClient()
        let repository = CityRepository(networkClient: networkClient)
        let fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        let viewModel = CityListViewModel(coordinator: coordinator, fetchCityListUseCase: fetchCityListUseCase)
        
        return viewModel
    }
    
    func buildMapViewModel(using cities: [CityLocation]) -> MapViewModelProtocol {
        MapViewModel(cities: cities)
    }
}
