//
//  AppContainer.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftData

final class AppContainer {
    
    static let shared = AppContainer()
    let coordinator = AppCoordinatorViewModel()
    private let networkClient = NetworkRestClient()
    
    var modelContainer: ModelContainer = {
        let schema = Schema([FavoriteCity.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    let modelContext: ModelContext

    private init() {
        modelContext = ModelContext(modelContainer)
    }

    func buildCityListViewModel() -> CityListViewModelProtocol {
        let repository = CityRepository(networkClient: networkClient)
        let favoriteRepository = FavoriteRepository(modelContext: modelContext)
        let fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        let mapLocationToCameraPositionUseCase = MapLocationToCameraPositionUseCase()
        let favoriteCityUseCase = FavoriteCityUseCase(repository: favoriteRepository)
        let filterUseCase = FilterCitiesUseCase()
        let viewModel = CityListViewModel(coordinator: coordinator,
                                          fetchCityListUseCase: fetchCityListUseCase,
                                          mapLocationToCameraPositionUseCase: mapLocationToCameraPositionUseCase,
                                          favoriteCityUseCase: favoriteCityUseCase,
                                          filterCitiesUseCase: filterUseCase)
        
        return viewModel
    }
    
    func buildMapViewModel(viewData: MapViewData) -> MapViewModelProtocol {
        MapViewModel(viewData: viewData)
    }
    
    func buildCityDetailViewModel(cityName: String, countryCode: String) -> CityDetailViewModel {
        let repository = CityRepository(networkClient: networkClient)
        let useCase = FetchCityDetailUseCase(repository: repository)
        let viewModel = CityDetailViewModel(cityName: cityName, countryCode: countryCode, useCase: useCase)
        
        return viewModel
    }
}
