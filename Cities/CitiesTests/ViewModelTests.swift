//
//  ViewModelTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Testing
@testable import Cities

struct ViewModelTests {
    
    //MARK: CityListViewModel
    struct CityListViewModelTests {
        let networkClient = NetworkClientMock()
        let viewModel: CityListViewModelProtocol
        
        init() {
            let cityRepository = CityRepository(networkClient: networkClient)
            let favoriteCityRepository = FavoriteRepositoryMock()
            let fetchCityLocationsUseCase = FetchCityLocationsUseCase(repository: cityRepository)
            let sortCitiesUseCase = SortCitiesUseCaseMock()
            let favoriteCityUseCase = FavoriteCityUseCase(repository: favoriteCityRepository)
            let filterCitiesUseCase = FilterCitiesUseCaseMock()
            let viewDataMapper = CityLocationViewDataMapper()
            let locationMapper = LocationMapper()
            let coordinator = CityListViewCoordinatorViewModelMock()
            viewModel = CityListViewModel(coordinator: coordinator,
                                          fetchCityListUseCase: fetchCityLocationsUseCase,
                                          sortCitiesUseCase: sortCitiesUseCase,
                                          favoriteCityUseCase: favoriteCityUseCase,
                                          filterCitiesUseCase: filterCitiesUseCase,
                                          viewDataMapper: viewDataMapper,
                                          locationMapper: locationMapper)
        }
        
        @Test(arguments: [[CityLocationDTO.mock, CityLocationDTO.mock],
                          [CityLocationDTO.mock],
                          []])
        func testLoadSuccess(dtos: [CityLocationDTO]) async {
            networkClient.dto = dtos
            await viewModel.load()
            if case .loaded(let viewData) = viewModel.state {
                #expect(viewData.cityLocations.count == dtos.count)
                
                // MapViewData must match the first location
                #expect(viewData.mapViewData?.position.region?.center.latitude == dtos.first?.coord.lat)
                #expect(viewData.mapViewData?.position.region?.center.latitude == dtos.first?.coord.lat)
            } else {
                #expect(Bool(false))
            }
        }
        
        @Test(arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error")])
        func testLoadFailure(customError: CustomError) async {
            networkClient.customError = customError
            await viewModel.load()
            
            if case .onError(let error) = viewModel.state {
                #expect(error == customError)
            } else {
                #expect(Bool(false))
            }
        }
    }
    
    //MARK: CityDetailViewModel
    struct CityDetailViewModelTests {
        let networkClient: NetworkClientMock
        let repository: CityRepositoryProtocol
        let fetchCityDetailUseCase: FetchCityDetailUseCaseProtocol
        let validateCityUseCase: ValidateCityUseCaseProtocol
        let viewModel: CityDetailViewModelProtocol
        
        init() {
            networkClient = NetworkClientMock()
            repository = CityRepository(networkClient: networkClient)
            fetchCityDetailUseCase = FetchCityDetailUseCase(repository: repository)
            validateCityUseCase = ValidateCityUseCase()
            viewModel = CityDetailViewModel(cityName: "Buenos Aires",
                                            countryCode: "AR",
                                            latitude: CityDetailDTO.mock.coordinates.lat,
                                            longitude: CityDetailDTO.mock.coordinates.lon,
                                            fetchCityDetailUseCase: fetchCityDetailUseCase,
                                            validateCityUseCase: validateCityUseCase)
        }
        
        @Test(arguments: [CityDetailDTO.mock])
        func testLoadSuccess(dto: CityDetailDTO) async throws {
            networkClient.dto = dto
            await viewModel.load()
            
            if case .loaded(let viewData) = viewModel.state {
                #expect(viewData.title == dto.title)
                #expect(viewData.description == dto.description)
                #expect(viewData.extract == dto.extract)
            } else {
                #expect(Bool(false))
            }
        }
        
        @Test(arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error")])
        func testLoadFailure(customError: CustomError) async throws {
            networkClient.customError = customError
            await viewModel.load()
            
            if case .onError = viewModel.state {
                #expect(true)
            } else {
                #expect(Bool(false))
            }
        }
    }
}
