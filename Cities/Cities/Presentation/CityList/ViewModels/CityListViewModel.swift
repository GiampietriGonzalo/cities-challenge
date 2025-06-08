//
//  CityListViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Observation

@Observable
final class CityListViewModel<Coordinator: CityListViewCoordinatorViewModelProtocol>: CityListViewModelProtocol {
    private let coordinator: Coordinator
    private let fetchCityListUseCase: FetchCityLocationsUseCaseProtocol
    private let mapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol
    private let favoriteCityUseCase: FavoriteCityUseCaseProtocol
    private var cityLocationViewDatas: [CityLocationViewData] = []
    private var cityLocationModels: [CityLocation] = []
    var state: CityListViewState = .loading
    
    init(coordinator: Coordinator,
         fetchCityListUseCase: FetchCityLocationsUseCaseProtocol,
         mapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol,
         favoriteCityUseCase: FavoriteCityUseCaseProtocol) {
        self.coordinator = coordinator
        self.fetchCityListUseCase = fetchCityListUseCase
        self.mapLocationToCameraPositionUseCase = mapLocationToCameraPositionUseCase
        self.favoriteCityUseCase = favoriteCityUseCase
    }
    
    @MainActor
    func load() async {
        self.state = .loading

        do {
            let result = try await fetchCityListUseCase.execute()
            self.cityLocationModels = result
            self.loadState()
        } catch let error {
            self.state = .onError(error)
        }
    }
   
    @MainActor
    private func loadState() {
        self.cityLocationViewDatas = cityLocationModels.map { mapToViewData(cityLocation: $0) }
        self.state = .loaded(.init(cityLocations: cityLocationViewDatas,
                                   mapViewData: buildMapViewData(cityLocation: cityLocationModels.first)))
    }
    
    @MainActor
    private func mapToViewData(cityLocation: CityLocation) -> CityLocationViewData {
        let title = cityLocation.name + ", " + cityLocation.country
        let subtitle = "lat: " + cityLocation.coordinate.latitude.description + ", lon: " + cityLocation.coordinate.longitude.description
        let buttonText = "Details"
        
        let onCitySelected: (Bool) -> Void = { [weak self] orientatioIsLandscape in
            guard let self else { return }
            let mapViewData = self.buildMapViewData(cityLocation: cityLocation)
            
            if orientatioIsLandscape {
                self.state = .loaded(.init(cityLocations: self.cityLocationViewDatas,
                                           mapViewData: mapViewData))
            } else if let mapViewData {
                self.coordinator.push(.map(viewData: mapViewData))
            }
        }
        
        let onFavoriteSelected: () -> Void = { [weak self]  in
            guard let self else { return }
            try? self.favoriteCityUseCase.insert(cityId: cityLocation.id)
        }
        
        return CityLocationViewData(id: cityLocation.id,
                                    title: title,
                                    subtitle: subtitle,
                                    detailButtonText: buttonText,
                                    onSelect: onCitySelected,
                                    onFavoriteSelected: onFavoriteSelected)
    }
    
    private func buildMapViewData(cityLocation: CityLocation?) -> MapViewData? {
        guard let cityLocation else { return nil }
        let cameraPositon = mapLocationToCameraPositionUseCase.execute(cityLocation)
        return MapViewData(position: cameraPositon, currentCityName: cityLocation.name, cities: cityLocationViewDatas)
    }
}
