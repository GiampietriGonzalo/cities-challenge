//
//  AppContainer.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftData

/// Singleton AppContainer. Enables Dependency Injection. Inititiaze the view models and all their dependencies.
final class AppContainer {
    
    static let shared = AppContainer()
    let coordinator = AppCoordinatorViewModel()
    private let networkClient = NetworkRestClient()
    
    lazy var modelContainer: ModelContainer = {
        let schema = Schema([FavoriteCity.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var modelContext: ModelContext {
        ModelContext(modelContainer)
    }

    private init() {}
    
    /**
     * Initialize a CityListViewModel with all it's dependencies.
     * - Returns: a CityListViewModel
     */
    func buildCityListViewModel() -> CityListViewModelProtocol {
        let repository = CityRepository(networkClient: networkClient)
        let favoriteRepository = FavoriteRepository(modelContext: modelContext)
        let fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        let sortCitiesUseCase = SortCitiesAlphabeticallyUseCase()
        let favoriteCityUseCase = FavoriteCityUseCase(repository: favoriteRepository)
        let viewDataMapper = CityLocationViewDataMapper()
        let locationMapper = LocationMapper()
        let filterUseCase = FilterCitiesUseCase()
        let viewModel = CityListViewModel(coordinator: coordinator,
                                          fetchCityListUseCase: fetchCityListUseCase,
                                          sortCitiesUseCase: sortCitiesUseCase,
                                          favoriteCityUseCase: favoriteCityUseCase,
                                          filterCitiesUseCase: filterUseCase,
                                          viewDataMapper: viewDataMapper,
                                          locationMapper: locationMapper)
        
        return viewModel
    }
    
    /**
     * Initialize a MapViewModel with all it's dependencies.
     * - Returns: a MapViewModel
     */
    func buildMapViewModel(viewData: MapViewData) -> MapViewModelProtocol {
        MapViewModel(viewData: viewData)
    }
    
    /**
     * Initialize a CityDetailViewModel with all it's dependencies.
     * - Returns: a CityDetailViewModel
     */
    func buildCityDetailViewModel(cityName: String, countryCode: String) -> CityDetailViewModel {
        let repository = CityRepository(networkClient: networkClient)
        let useCase = FetchCityDetailUseCase(repository: repository)
        let viewModel = CityDetailViewModel(cityName: cityName, countryCode: countryCode, useCase: useCase)
        
        return viewModel
    }
}
