//
//  CityListTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import Testing
@testable import Cities

struct CityListTests {
    
    struct ViewModel {
        let networkClient = NetworkClientMock()
        let viewModel: CityListViewModelProtocol
        
        init() {
            let repository = CityRepository(networkClient: networkClient)
            let useCase = FetchCityLocationsUseCase(repository: repository)
            viewModel = CityListViewModel(fetchCityListUseCase: useCase)
        }
        
        @Test(.tags(.presentation), arguments: [[CityLocationDTO.mock, CityLocationDTO.mock],
                                                [],
                                                [CityLocationDTO.mock]])
        func load(dtos: [CityLocationDTO]) async {
            networkClient.dto = dtos
            await viewModel.load()
            if case .loaded(let cities) = viewModel.viewData.state {
                #expect(cities.count == dtos.count)
            } else {
                #expect(Bool(false))
            }
        }
        
        @Test(.tags(.presentation),
              arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error"),
                          CustomError.networkError("network error"),
                          CustomError.unknown])
        
        func load_error(customError: CustomError) async {
            networkClient.customError = customError
            await viewModel.load()
            
            if case .onError(let error) = viewModel.viewData.state {
                #expect(error == customError)
            } else {
                #expect(Bool(false))
            }
        }
    }

}
