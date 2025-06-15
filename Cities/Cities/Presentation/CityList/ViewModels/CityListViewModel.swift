//
//  CityListViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Observation
import Combine

@Observable
final class CityListViewModel<Coordinator: AppCoordinatorViewModelProtocol>: CityListViewModelProtocol {
    
    //MARK: Dependencies
    private let coordinator: Coordinator
    private let fetchCityListUseCase: FetchCityLocationsUseCaseProtocol
    private let sortCitiesUseCase: SortCitiesUseCaseProtocol
    private let favoriteCityUseCase: FavoriteCityUseCaseProtocol
    private let filterCitiesUseCase: FilterCitiesUseCaseProtocol
    private let viewDataMapper: CityLocationMapperProtocol
    private let locationMapper: LocationMapperProtocol
    
    //MARK: Useful properties
    private var fullCityLocationViewDatas: [CityLocationViewData] = []
    private var currentCityLocationViewDatas: [CityLocationViewData] = []
    private var cityModelsDictionary: [Int: CityLocation] = [:]
    private var cityModels: [CityLocation] { Array(cityModelsDictionary.values) }
    private var favoriteCityIds: Set<Int> = []
    
    private var mapViewData: MapViewData?
    private var isFilteringByFavorite: Bool = false
    private var textToFilter: String?
    
    //MARK: Observed State
    var state: CityListViewState = .loading
    
    //MARK: Pubishers
    private var subscriptions: Set<AnyCancellable> = []
    private let actionPublisher: PassthroughSubject<CityListAction, Never> = .init()
    private let onFilterPublisher: PassthroughSubject<String, Never> = .init()
    private let onFilterByFavoritesPublisher: PassthroughSubject<Bool, Never> = .init()
    
    init(coordinator: Coordinator,
         fetchCityListUseCase: FetchCityLocationsUseCaseProtocol,
         sortCitiesUseCase: SortCitiesUseCaseProtocol,
         favoriteCityUseCase: FavoriteCityUseCaseProtocol,
         filterCitiesUseCase: FilterCitiesUseCaseProtocol,
         viewDataMapper: CityLocationMapperProtocol,
         locationMapper: LocationMapperProtocol) {
        self.coordinator = coordinator
        self.fetchCityListUseCase = fetchCityListUseCase
        self.sortCitiesUseCase = sortCitiesUseCase
        self.favoriteCityUseCase = favoriteCityUseCase
        self.filterCitiesUseCase = filterCitiesUseCase
        self.viewDataMapper = viewDataMapper
        self.locationMapper = locationMapper
        self.subscribeToPublishers()
    }
    
    @MainActor
    func load() async {
        self.state = .loading
        
        do {
            let result = try await fetchCityListUseCase.execute()
            let sortedResult = sortCitiesUseCase.execute(cities: result)
            self.buildCityModelsDictionary(with: sortedResult)
            self.configureProperties(with: sortedResult)
            self.filterCitiesUseCase.setup(with: sortedResult)
            self.applyFilters()
        } catch let error {
            self.state = .onError(error)
        }
    }
    
}

//MARK: Configuration
private extension CityListViewModel {
    
    func subscribeToPublishers() {
        actionPublisher.sink { [weak self] action in
            guard let self else { return }
            
            switch action {
            case let .select(cityId, orientationisLandscape):
                self.handleOnSelectCity(cityId: cityId, orientationIsLandscape: orientationisLandscape)
            case let .seeDetail(cityId):
                self.handleSeeDetails(cityId: cityId)
            case let .tapFavorite(cityId):
                self.handleTapOnFavorite(cityId: cityId)
            }
        }.store(in: &subscriptions)
        
        onFilterPublisher.sink { [weak self] text in
            guard let self else { return }
            self.textToFilter = text
            self.applyFilters()
            
        }.store(in: &subscriptions)
        
        onFilterByFavoritesPublisher.sink { [weak self] isFilteringByFavorites in
            guard let self else { return }
            self.isFilteringByFavorite = isFilteringByFavorites
            applyFilters()
        }.store(in: &subscriptions)
    }
    
    func buildCityModelsDictionary(with cities: [CityLocation]) {
        cities.forEach { cityModelsDictionary[$0.id] = $0 }
    }
    
    func configureProperties(with cities: [CityLocation]) {
        self.fullCityLocationViewDatas = mapToViewData(cities: cities)
        self.mapViewData = buildMapViewData(cityLocation: cities.first)
        
        do {
            self.favoriteCityIds = Set(try favoriteCityUseCase.getFavorites())
        } catch {
            self.state = .onError(error)
        }
        
    }
    
    func loadState(with cityViewDatas: [CityLocationViewData]) {
        self.state = .loaded(.init(cityLocations: cityViewDatas,
                                   mapViewData: mapViewData,
                                   onFilterPublisher: onFilterPublisher,
                                   onFilterByFavoritesPublisher:onFilterByFavoritesPublisher))
    }
}

//MARK: Filters
private extension CityListViewModel {
    func applyFilters() {
        if isFilteringByFavorite {
            self.currentCityLocationViewDatas = fullCityLocationViewDatas.filter { favoriteCityIds.contains($0.id) }
            
            if let textToFilter, !textToFilter.isEmpty {
                let filterCities =  filterCitiesUseCase.execute(cities: cityModels, filterBy: textToFilter)
                let viewDatasFilterByText = mapToViewData(cities: filterCities)
                let commonViewDatasBetweenCurrentAndFiltered = Array(Set(currentCityLocationViewDatas).intersection(Set(viewDatasFilterByText)))
                
                let modelsToSort = cityModelsDictionary.filter { entry in
                    commonViewDatasBetweenCurrentAndFiltered.contains(where: { entry.key == $0.id })
                }
                
                let sorted = sortCitiesUseCase.execute(cities: Array(modelsToSort.values))
                self.currentCityLocationViewDatas = mapToViewData(cities: sorted)
            }
        } else if let textToFilter {
            let sortedModels = sortCitiesUseCase.execute(cities: cityModels)
            let filterCities =  filterCitiesUseCase.execute(cities: sortedModels, filterBy: textToFilter)
            self.currentCityLocationViewDatas = mapToViewData(cities: filterCities)
        } else {
            self.currentCityLocationViewDatas = fullCityLocationViewDatas
        }
        
        
        self.state = .loaded(.init(
            cityLocations: currentCityLocationViewDatas,
            mapViewData: mapViewData,
            onFilterPublisher: onFilterPublisher,
            onFilterByFavoritesPublisher: onFilterByFavoritesPublisher
        ))
    }
}

//MARK: Map Data
private extension CityListViewModel {
    func mapToViewData(cities: [CityLocation]) -> [CityLocationViewData] {
        cities.map { viewDataMapper.map(from: $0, actionPublisher: actionPublisher) }
    }
    
    func buildMapViewData(cityLocation: CityLocation?) -> MapViewData? {
        guard let cityLocation else { return nil }
        let cameraPositon = locationMapper.map(cityLocation)
        return MapViewData(position: cameraPositon,
                           currentCityName: cityLocation.name,
                           cities: currentCityLocationViewDatas)
    }
}

//MARK: Handle Actions
private extension CityListViewModel {
    func handleOnSelectCity(cityId: Int, orientationIsLandscape: Bool) {
        guard let cityLocation = self.getCity(for: cityId) else { return }
        
        let mapViewData = self.buildMapViewData(cityLocation: cityLocation)
        let locationsViewDatas = self.currentCityLocationViewDatas
        
        if orientationIsLandscape {
            self.state = .loaded(.init(cityLocations: locationsViewDatas,
                                       mapViewData: mapViewData,
                                       onFilterPublisher: onFilterPublisher,
                                       onFilterByFavoritesPublisher: onFilterByFavoritesPublisher))
        } else if let mapViewData {
            self.coordinator.push(.map(viewData: mapViewData))
        }
    }
    
    func handleSeeDetails(cityId: Int) {
        guard let cityLocation = self.getCity(for: cityId) else { return }
        self.coordinator.push(.detail(cityName: cityLocation.name,
                                      countryCode: cityLocation.country,
                                      latitude: cityLocation.coordinate.latitude,
                                      longitude: cityLocation.coordinate.longitude))
    }
    
    func handleTapOnFavorite(cityId: Int) {
        try? self.favoriteCityUseCase.insert(cityId: cityId)
        self.updateFavoritesLocalPersistance(with: cityId)
        self.applyFilters()
    }
    
    func handleTapOnFilterByFavorite(isFilteringByFavorite: Bool) {
        self.isFilteringByFavorite = isFilteringByFavorite
        self.applyFilters()
    }
    
    func getCity(for id: Int) -> CityLocation? {
        cityModels.first { $0.id == id }
    }
    
    func updateFavoritesLocalPersistance(with id: Int) {
        if favoriteCityIds.contains(id) {
            self.favoriteCityIds.remove(id)
        } else {
            self.favoriteCityIds.insert(id)
        }
    }
}
