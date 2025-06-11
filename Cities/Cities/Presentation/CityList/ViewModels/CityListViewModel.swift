//
//  CityListViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Observation

@Observable
final class CityListViewModel<Coordinator: AppCoordinatorViewModelProtocol>: CityListViewModelProtocol {
    
    //MARK: Dependencies
    private let coordinator: Coordinator
    private let fetchCityListUseCase: FetchCityLocationsUseCaseProtocol
    private let sortCitiesUseCase: SortCitiesUseCaseProtocol
    private let mapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol
    private let favoriteCityUseCase: FavoriteCityUseCaseProtocol
    private let filterCitiesUseCase: FilterCitiesUseCaseProtocol
    
    //MARK: Useful properties
    private var cityLocationViewDatas: [CityLocationViewData] = []
    private var filteredCityLocationViewDatas: [CityLocationViewData] = []
    private var cityLocationModels: [CityLocation] = []
    private var mapViewData: MapViewData?
    
    //MARK: Observed State
    var state: CityListViewState = .loading
    
    init(coordinator: Coordinator,
         fetchCityListUseCase: FetchCityLocationsUseCaseProtocol,
         sortCitiesUseCase: SortCitiesUseCaseProtocol,
         mapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol,
         favoriteCityUseCase: FavoriteCityUseCaseProtocol,
         filterCitiesUseCase: FilterCitiesUseCaseProtocol) {
        self.coordinator = coordinator
        self.fetchCityListUseCase = fetchCityListUseCase
        self.sortCitiesUseCase = sortCitiesUseCase
        self.mapLocationToCameraPositionUseCase = mapLocationToCameraPositionUseCase
        self.favoriteCityUseCase = favoriteCityUseCase
        self.filterCitiesUseCase = filterCitiesUseCase
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
   
    private func loadState(with cityViewDatas: [CityLocationViewData]) {
        self.state = .loaded(.init(cityLocations: cityViewDatas,
                                   mapViewData: mapViewData,
                                   onFilter: onFilter))
    }
    
    private func configureProperties(with cities: [CityLocation]) {
        self.cityLocationViewDatas = cities.map { mapToViewData(cityLocation: $0) }
        self.mapViewData = buildMapViewData(cityLocation: cityLocationModels.first)
    }
    
    //TODO: Refact to a Use Case or Mapper
    private func mapToViewData(cityLocation: CityLocation) -> CityLocationViewData {
        let title = cityLocation.name + ", " + cityLocation.country
        let subtitle = "lat: " + cityLocation.coordinate.latitude.description + ", lon: " + cityLocation.coordinate.longitude.description
        let buttonText = "Details"
        
        let onCitySelected: (Bool) -> Void = { [weak self] orientatioIsLandscape in
            guard let self else { return }
            let mapViewData = self.buildMapViewData(cityLocation: cityLocation)
            let locationsViewDatas = filteredCityLocationViewDatas.isEmpty ? self.cityLocationViewDatas : self.filteredCityLocationViewDatas
            
            if orientatioIsLandscape {
                self.state = .loaded(.init(cityLocations: locationsViewDatas,
                                           mapViewData: mapViewData,
                                           onFilter: self.onFilter))
            } else if let mapViewData {
                self.coordinator.push(.map(viewData: mapViewData))
            }
        }
        
        let onFavoriteTap: () -> Void = { [weak self]  in
            guard let self else { return }
            try? self.favoriteCityUseCase.insert(cityId: cityLocation.id)
        }
        
        let onDetailTap: () -> Void = { [weak self] in
            guard let self else { return }
            self.coordinator.push(.detail(cityName: cityLocation.name, countryCode: cityLocation.country))
        }
        
        return CityLocationViewData(id: cityLocation.id,
                                    title: title,
                                    subtitle: subtitle,
                                    detailButtonText: buttonText,
                                    onSelect: onCitySelected,
                                    onFavoriteTap: onFavoriteTap,
                                    onDetailButtonTap: onDetailTap)
    }
    
    //TODO: Refact to a Use Case or Mapper
    private func buildMapViewData(cityLocation: CityLocation?) -> MapViewData? {
        guard let cityLocation else { return nil }
        let cameraPositon = mapLocationToCameraPositionUseCase.execute(cityLocation)
        return MapViewData(position: cameraPositon,
                           currentCityName: cityLocation.name,
                           cities: cityLocationViewDatas)
    }
    
    @Sendable private func onFilter(text: String) {
        self.filteredCityLocationViewDatas = filterCitiesUseCase.execute(cities: cityLocationViewDatas, filterBy: text)
        self.loadState(with: filteredCityLocationViewDatas)
    }
}
