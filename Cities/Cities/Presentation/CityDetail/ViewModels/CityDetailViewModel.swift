//
//  CityDetailViewModel.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

import Observation

@Observable
final class CityDetailViewModel: CityDetailViewModelProtocol {
    
    //MARK: Dependencies
    private let cityName: String
    private let countryCode: String
    private let useCase: FetchCityDetailUseCaseProtocol

    //MARK: Observed State
    var state: CityDetailState = .loading
    
    init(cityName: String, countryCode: String, useCase: FetchCityDetailUseCaseProtocol) {
        self.cityName = cityName
        self.countryCode = countryCode
        self.useCase = useCase
    }
    
    @MainActor
    func load() async {
        do {
            let cityDetail = try await useCase.execute(name: cityName, countryCode: countryCode)
            state = .loaded(viewData: cityDetail.mapToViewData())
        } catch {
            state = .onError(error: error)
        }
    }
}
