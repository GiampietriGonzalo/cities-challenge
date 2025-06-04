//
//  CityListViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Observation

@Observable
final class CityListViewModel: CityListViewModelProtocol {
    private let fetchCityListUseCase: FetchCityLocationsUseCaseProtocol
    var viewData: CityListViewData = .init(state: .loading)
    
    init(fetchCityListUseCase: FetchCityLocationsUseCaseProtocol) {
        self.fetchCityListUseCase = fetchCityListUseCase
    }
    
    func load() async {
        viewData.state = .loading

        do {
            let result = try await fetchCityListUseCase.execute()
            let cityLocationViewDatas = result.map { mapToViewData(cityLocation: $0) }
            self.viewData.state = .loaded(cityLocationViewDatas)
        } catch let error {
            self.viewData.state = .onError(error)
        }
    }
    
    private func mapToViewData(cityLocation: CityLocation) -> CityLocationViewData {
        let title = cityLocation.name + ", " + cityLocation.country
        let subtitle = "latitude: " + cityLocation.coordinate.latitude.description + ", longitude: " + cityLocation.coordinate.longitude.description
        let buttonText = "Show Details"
        
        return CityLocationViewData(title: title,
                                    subtitle: subtitle,
                                    detailButtonText: buttonText)
    }
}
