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
    private let latitude: Double
    private let longitude: Double
    private let fetchCityDetailUseCase: FetchCityDetailUseCaseProtocol
    private let validateCityUseCase: ValidateCityUseCaseProtocol

    //MARK: Observed State
    var state: CityDetailState = .loading
    
    init(cityName: String, countryCode: String, latitude: Double, longitude: Double, fetchCityDetailUseCase: FetchCityDetailUseCaseProtocol, validateCityUseCase: ValidateCityUseCaseProtocol) {
        self.cityName = cityName
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
        self.fetchCityDetailUseCase = fetchCityDetailUseCase
        self.validateCityUseCase = validateCityUseCase
    }
    
    @MainActor
    func load() async {
        do {
            let cityDetail = try await fetchCityDetailUseCase.execute(name: cityName, countryCode: countryCode)
            let cityIsValid = validateCityUseCase.execute(city: cityDetail, latitude: latitude, longitude: longitude)
            
            if cityIsValid {
                state = .loaded(viewData: cityDetail.mapToViewData())
            } else {
                state = .onError
            }
        } catch {
            state = .onError
        }
    }
}
