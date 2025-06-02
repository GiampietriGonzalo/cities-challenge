//
//  AppContainer.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

struct AppContainer {
    
    func buildCityListViewModel() -> CityListViewModelProtocol {
        let networkClient = NetworkRestClient()
        let repository = CityRepository(networkClient: networkClient)
        let fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        let viewModel = CityListViewModel(fetchCityListUseCase: fetchCityListUseCase)
        
        return viewModel
    }
    
}
