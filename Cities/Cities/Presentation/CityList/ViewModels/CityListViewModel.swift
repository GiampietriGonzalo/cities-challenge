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
    private var cityLocationViewDatas: [CityLocationViewData] = []
    private var filteredCityLocationViewDatas: [CityLocationViewData] = []
    private var cityLocationModels: [CityLocation] = []
    private var mapViewData: MapViewData?
    
    //MARK: Observed State
    var state: CityListViewState = .loading
    
    //MARK: Pubishers
    private var subscriptions: Set<AnyCancellable> = []
    private let actionPublisher: PassthroughSubject<CityListAction, Never> = .init()
    private let onFilterPublisher: PassthroughSubject<String, Never> = .init()
    
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
            self.cityLocationModels = sortCitiesUseCase.execute(cities: result)
            self.configureProperties(with: cityLocationModels)
            self.filterCitiesUseCase.setup(with: cityLocationViewDatas)
            self.loadState(with: cityLocationViewDatas)
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
            self.filteredCityLocationViewDatas = filterCitiesUseCase.execute(cities: cityLocationViewDatas, filterBy: text)
            self.loadState(with: filteredCityLocationViewDatas)
        }
        .store(in: &subscriptions)
    }
    
    func configureProperties(with cities: [CityLocation]) {
        self.cityLocationViewDatas = cities.map { mapToViewData(cityLocation: $0) }
        self.mapViewData = buildMapViewData(cityLocation: cityLocationModels.first)
    }
    
    func loadState(with cityViewDatas: [CityLocationViewData]) {
        self.state = .loaded(.init(cityLocations: cityViewDatas,
                                   mapViewData: mapViewData,
                                   onFilterPublisher: onFilterPublisher))
    }
}

//MARK: Map Data
private extension CityListViewModel {
    func mapToViewData(cityLocation: CityLocation) -> CityLocationViewData {
        viewDataMapper.map(from: cityLocation, actionPublisher: actionPublisher)
    }
    
    func buildMapViewData(cityLocation: CityLocation?) -> MapViewData? {
        guard let cityLocation else { return nil }
        let cameraPositon = locationMapper.map(cityLocation)
        return MapViewData(position: cameraPositon,
                           currentCityName: cityLocation.name,
                           cities: cityLocationViewDatas)
    }
}

//MARK: Handle Actions
private extension CityListViewModel {
    func handleOnSelectCity(cityId: Int, orientationIsLandscape: Bool) {
        guard let cityLocation = self.getCity(for: cityId) else { return }
        
        let mapViewData = self.buildMapViewData(cityLocation: cityLocation)
        let locationsViewDatas = filteredCityLocationViewDatas.isEmpty ? self.cityLocationViewDatas : self.filteredCityLocationViewDatas
        
        if orientationIsLandscape {
            self.state = .loaded(.init(cityLocations: locationsViewDatas,
                                       mapViewData: mapViewData,
                                       onFilterPublisher: onFilterPublisher))
        } else if let mapViewData {
            self.coordinator.push(.map(viewData: mapViewData))
        }
    }
    
    func handleSeeDetails(cityId: Int) {
        guard let cityLocation = self.getCity(for: cityId) else { return }
        self.coordinator.push(.detail(cityName: cityLocation.name, countryCode: cityLocation.country))
    }
    
    func handleTapOnFavorite(cityId: Int) {
        try? self.favoriteCityUseCase.insert(cityId: cityId)
    }
    
    func getCity(for id: Int) -> CityLocation? {
        cityLocationModels.first { $0.id == id }
    }
}
