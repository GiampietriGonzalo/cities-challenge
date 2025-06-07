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
    private var cityLocationViewDatas: [CityLocationViewData] = []
    var state: CityListViewState = .loading
    
    init(coordinator: Coordinator, fetchCityListUseCase: FetchCityLocationsUseCaseProtocol, mapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol) {
        self.coordinator = coordinator
        self.fetchCityListUseCase = fetchCityListUseCase
        self.mapLocationToCameraPositionUseCase = mapLocationToCameraPositionUseCase
    }
    
    func load() async {
        self.state = .loading

        do {
            let result = try await fetchCityListUseCase.execute()
            self.cityLocationViewDatas = result.map { mapToViewData(cityLocation: $0) }
            self.state = .loaded(.init(cityLocations: cityLocationViewDatas,
                                       mapViewData: buildMapViewData(cityLocation: result.first)))
        } catch let error {
            self.state = .onError(error)
        }
    }
   
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
        
        return CityLocationViewData(title: title,
                                    subtitle: subtitle,
                                    detailButtonText: buttonText,
                                    onSelect: onCitySelected)
    }
    
    private func buildMapViewData(cityLocation: CityLocation?) -> MapViewData? {
        guard let cityLocation else { return nil }
        let cameraPositon = mapLocationToCameraPositionUseCase.execute(cityLocation)
        return MapViewData(position: cameraPositon, currentCityName: cityLocation.name, cities: cityLocationViewDatas)
    }
}
