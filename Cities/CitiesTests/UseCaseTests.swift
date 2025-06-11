//
//  UseCaseTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 11/06/2025.
//

import Testing
@testable import Cities

struct UseCasesTests {
    struct FetchtCityDetail {
        let networkClient = NetworkClientMock()
        let repository: CityRepositoryProtocol
        let fetchCityDetailUseCase: FetchCityDetailUseCaseProtocol
        
        init() {
            repository = CityRepository(networkClient: networkClient)
            fetchCityDetailUseCase = FetchCityDetailUseCase(repository: repository)
        }
        
        @Test(arguments: [("New York", "US"), ("", ""), ("", "AR"), ("Tandil", "")])
        func fetchCityListSuccessfully(cityName: String, countryCode: String) async throws {
            networkClient.dto = CityDetailDTO(title: cityName,
                                              description: countryCode,
                                              extract: "",
                                              originalimage: .init(source: ""),
                                              coordinates: .init(lat: 0, lon: 0))
            
            let result = try await fetchCityDetailUseCase.execute(name: cityName,
                                                                countryCode: countryCode)
            
            #expect(result.title == cityName)
            #expect(result.countryCode == countryCode)
        }
        
        @Test(arguments: [CustomError.decodeError("decode error"),
                          CustomError.serviceError("service error"),
                          CustomError.invalidUrl("invalid url")])
        func fetchCityListFail(with error: CustomError) async throws {
            networkClient.customError = error
            networkClient.dto = nil
            
            do {
                _ = try await fetchCityDetailUseCase.execute(name: "name",
                                                           countryCode: "code")
            } catch {
                #expect(networkClient.customError == error)
            }
        }
    }
    
    struct FetchCityLocations {
        let networkClient = NetworkClientMock()
        let repository: CityRepositoryProtocol
        let fetchCityListUseCase: FetchCityLocationsUseCaseProtocol
        
        init() {
            repository = CityRepository(networkClient: networkClient)
            fetchCityListUseCase = FetchCityLocationsUseCase(repository: repository)
        }
        
        @Test(arguments: [[],
                          [CityLocationDTO.mock],
                          [CityLocationDTO.mock, CityLocationDTO.mock]])
        func fetchCityLocationsSuccessfully(dtos: [CityLocationDTO]) async throws {
            networkClient.dto = dtos
            let result = try await fetchCityListUseCase.execute()
            
            #expect(result.count == dtos.count)
            
            for model in result {
                #expect(dtos.contains(where: { $0._id == model.id}))
            }
        }
        
        @Test(arguments: [CustomError.decodeError("decode error"),
                          CustomError.serviceError("service error"),
                          CustomError.invalidUrl("invalid url")])
        func testCityLocationsFailure(error: CustomError) async throws {
            networkClient.dto = nil
            networkClient.customError = error
            do {
                _ = try await fetchCityListUseCase.execute()
            } catch {
                #expect(error == networkClient.customError)
            }
        }
        
    }
    
    struct SortCities {
        let sortCitiesUseCase: SortCitiesUseCaseProtocol
        
        init() {
            sortCitiesUseCase = SortCitiesAlphabeticallyUseCase()
        }
        
        @Test(arguments: [[],
                          [CityLocation.mockA, .mockB, .mockZ]])
        func testSort(cities: [CityLocation]) {
            let result = sortCitiesUseCase.execute(cities: cities)
            
            #expect(result.count == cities.count)
            
            if !result.isEmpty {
                #expect(result.first == .mockA)
                #expect(result.last == .mockZ)
            }
        }
    }
    
    struct FavoriteCity {
        let repository: FavoriteRepositoryMock
        let favoriteCityUseCase: FavoriteCityUseCaseProtocol
        
        init() {
            repository = FavoriteRepositoryMock()
            favoriteCityUseCase = FavoriteCityUseCase(repository: repository)
        }
        
        @Test
        func testInsertFavoriteCitySuccessfully() {
            do {
                let id = 123
                try favoriteCityUseCase.insert(cityId: id)
                #expect(repository.favoriteCities.contains(where: { $0.id == id }))
            } catch {
                #expect(Bool(false))
            }
        }
        
        @Test
        func testInsertFavoriteCityFail() {
            repository.error = .serviceError("service error")
            
            do {
                try favoriteCityUseCase.insert(cityId: 123)
            } catch {
                #expect(error == repository.error)
            }
        }
    }
    
    struct MapLocationtoCameraPosition {
        let useCase: MapLocationToCameraPositionUseCaseProtocol
        
        init() {
            useCase = MapLocationToCameraPositionUseCase()
        }
        
        @Test
        func mapLocationToCameraPosition() {
            let cityLocation = CityLocation.mock
            let result = useCase.execute(cityLocation)
            
            guard let region = result.region else {
                #expect(Bool(false))
                return
            }
            
            #expect(region.center.latitude == cityLocation.coordinate.latitude)
            #expect(region.center.longitude == cityLocation.coordinate.longitude)
        }
    }
    
    struct FilterCities {

       private let cities: [CityLocationViewData] = [
           CityLocationViewData(id: 1, title: "Alabama", subtitle: "subtitle", detailButtonText: "detail", onSelect: { _ in }, onFavoriteTap: {}, onDetailButtonTap: {}),
           
           CityLocationViewData(id: 2, title: "Albuquerque", subtitle: "subtitle", detailButtonText: "detail", onSelect: { _ in }, onFavoriteTap: {}, onDetailButtonTap: {}),
           
           CityLocationViewData(id: 3, title: "Anaheim", subtitle: "subtitle", detailButtonText: "detail", onSelect: { _ in }, onFavoriteTap: {}, onDetailButtonTap: {}),
           
           CityLocationViewData(id: 4, title: "Arizona", subtitle: "subtitle", detailButtonText: "detail", onSelect: { _ in }, onFavoriteTap: {}, onDetailButtonTap: {})
       ]
       
       let useCase: FilterCitiesUseCaseProtocol
       
       init() {
           useCase = FilterCitiesUseCase()
           useCase.setup(with: cities)
       }
       

       @Test func filterExactPrefix() {
           let result = useCase.execute(cities: cities, filterBy: "Al")
           let expected = ["Alabama", "Albuquerque"]
           let resultNames = result.map { $0.title }

           #expect(resultNames == expected)
       }

       @Test func filterSingleCity() {
           let result = useCase.execute(cities: cities, filterBy: "Alb")

           #expect(result.count == 1)
           #expect(result.first?.title == "Albuquerque")
       }

       @Test func filterCaseInsensitive() {
           let result = useCase.execute(cities: cities, filterBy: "a")
           let resultNames = result.map { $0.title }
           let expected = ["Alabama", "Albuquerque", "Anaheim", "Arizona"]

           #expect(resultNames == expected)
       }

       @Test func filterNotMatch() {
           let result = useCase.execute(cities: cities, filterBy: "xyz")
           #expect(result.isEmpty)
       }

       @Test func emptyPrefix() {
           let result = useCase.execute(cities: cities, filterBy: "")
           #expect(result.count == cities.count)
       }
        
        @Test func emptyList() {
            let useCase = FilterCitiesUseCase()
            useCase.setup(with: [])
            let result = useCase.execute(cities: [], filterBy: "a")
            #expect(result.count == 0)
        }
   }

}
