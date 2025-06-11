//
//  ViewModelTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Testing
@testable import Cities

struct ViewModelTests {
    
    struct CityList {
        let networkClient = NetworkClientMock()
        let viewModel: CityListViewModelProtocol
        
        init() {
            let cityRepository = CityRepository(networkClient: networkClient)
            let favoriteCityRepository = FavoriteRepositoryMock()
            let fetchCityLocationsUseCase = FetchCityLocationsUseCase(repository: cityRepository)
            let sortCitiesUseCase = SortCitiesUseCaseMock()
            let mapLocationToCameraPositionUseCase = MapLocationToCameraPositionUseCase()
            let favoriteCityUseCase = FavoriteCityUseCase(repository: favoriteCityRepository)
            let filterCitiesUseCase = FilterCitiesUseCaseMock()
            let coordinator = CityListViewCoordinatorViewModelMock()
            viewModel = CityListViewModel(coordinator: coordinator,
                                          fetchCityListUseCase: fetchCityLocationsUseCase,
                                          sortCitiesUseCase: sortCitiesUseCase,
                                          mapLocationToCameraPositionUseCase: mapLocationToCameraPositionUseCase,
                                          favoriteCityUseCase: favoriteCityUseCase,
                                          filterCitiesUseCase: filterCitiesUseCase)
        }
        
        @Test(arguments: [[CityLocationDTO.mock, CityLocationDTO.mock],
                                                [],
                                                [CityLocationDTO.mock]])
        func load(dtos: [CityLocationDTO]) async {
            networkClient.dto = dtos
            await viewModel.load()
            if case .loaded(let viewData) = viewModel.state {
                #expect(viewData.cityLocations.count == dtos.count)
            } else {
                #expect(Bool(false))
            }
        }
        
        @Test(arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error")])
        
        func load_error(customError: CustomError) async {
            networkClient.customError = customError
            await viewModel.load()
            
            if case .onError(let error) = viewModel.state {
                #expect(error == customError)
            } else {
                #expect(Bool(false))
            }
        }
    }
    
    struct CityDetail {
        let networkClient: NetworkClientProtocol
        let repository: CityRepositoryProtocol
        let useCase: FetchCityDetailUseCaseProtocol
        let viewModel: CityDetailViewModelProtocol
        
        init() {
            networkClient = NetworkClientMock()
            repository = CityRepository(networkClient: networkClient)
            useCase = FetchCityDetailUseCase(repository: repository)
            viewModel = CityDetailViewModel(cityName: "Buenos Aires",
                                            countryCode: "AR",
                                            useCase: useCase)
        }
    }
}
