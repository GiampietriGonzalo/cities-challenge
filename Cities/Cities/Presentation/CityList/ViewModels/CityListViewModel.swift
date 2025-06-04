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
            self.viewData.state = .loaded(result)
        } catch let error {
            self.viewData.state = .onError(error)
        }
    }
}
