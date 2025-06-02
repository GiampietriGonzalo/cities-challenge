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
    
    func load() {
        viewData.state = .loading
        Task {
            do {
                let result = try await fetchCityListUseCase.execute()
                self.viewData.state = .loaded(result)
            } catch let error as CustomError {
                self.viewData.state = .onError(error)
            }
        }
    }
}
