//
//  UseCaseTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 11/06/2025.
//

import Testing
@testable import Cities

struct UseCasesTests {
    
    //MARK: FetchCityDetailUseCase
    struct FetchtCityDetailUseCaseTests {
        let networkClient = NetworkClientMock()
        let repository: CityRepositoryProtocol
        let fetchCityDetailUseCase: FetchCityDetailUseCaseProtocol
        
        init() {
            repository = CityRepository(networkClient: networkClient)
            fetchCityDetailUseCase = FetchCityDetailUseCase(repository: repository)
        }
        
        @Test(arguments: [("New York", "US"), ("Tandil", "")])
        func fetchCityListSuccess(cityName: String, countryCode: String) async throws {
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
        
        @Test
        func fetchCityFailureWithEmptyName() async throws {
            do {
                _ = try await fetchCityDetailUseCase.execute(name: "",
                                                             countryCode: "")
                #expect(Bool(false))
            } catch {
                #expect(error == .serviceError("City name is empty"))
            }
        }
        
        @Test(arguments: [CustomError.decodeError("decode error"),
                          CustomError.serviceError("service error"),
                          CustomError.invalidUrl("invalid url")])
        func fetchCityListFail(with customError: CustomError) async throws {
            networkClient.customError = customError
            networkClient.dto = nil
            
            do {
                _ = try await fetchCityDetailUseCase.execute(name: "name", countryCode: "code")
                #expect(Bool(false))
            } catch {
                #expect(error == customError)
            }
        }
    }
    
    //MARK: FetchCityLocationsUseCase
    struct FetchCityLocationsUseCaseTests {
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
        func fetchCityLocationsSuccess(dtos: [CityLocationDTO]) async throws {
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
                #expect(Bool(false))
            } catch {
                #expect(error == networkClient.customError)
            }
        }
        
    }
    
    //MARK: SortCitiesUseCase
    struct SortCitiesUseCaseTests {
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
    
    //MARK: FavoriteCityUseCase
    struct FavoriteCityUseCaseTests {
        let repository: FavoriteRepositoryMock
        let favoriteCityUseCase: FavoriteCityUseCaseProtocol
        
        init() {
            repository = FavoriteRepositoryMock()
            favoriteCityUseCase = FavoriteCityUseCase(repository: repository)
        }
        
        @Test
        func testInsertFavoriteCitySuccess() {
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
            let customError = CustomError.serviceError("service error")
            repository.error = customError
            
            do {
                try favoriteCityUseCase.insert(cityId: 123)
                #expect(Bool(false))
            } catch {
                #expect(error == customError)
            }
        }
    }
    
    //MARK: FilterCitiesUseCase
    struct FilterCitiesUseCaseTests {

       private let cities: [CityLocation] = [
        .init(id: 1, name: "Buenos Aires", country: "AR", coordinate: .init(latitude: 0, longitude: 0)),
        .init(id: 2, name: "Bahía Blanca", country: "AR", coordinate: .init(latitude: 0, longitude: 0)),
        .init(id: 3, name: "Salta", country: "AR", coordinate: .init(latitude: 0, longitude: 0)),
        .init(id: 4, name: "Suarez", country: "AR", coordinate: .init(latitude: 0, longitude: 0)),
        .init(id: 3, name: "Santiago del Estero", country: "AR", coordinate: .init(latitude: 0, longitude: 0)),
        .init(id: 3, name: "Santiago", country: "CL", coordinate: .init(latitude: 0, longitude: 0))
       ]
       let useCase: FilterCitiesUseCaseProtocol
       
       init() {
           useCase = FilterCitiesUseCase()
           useCase.setup(with: cities)
       }
       

       @Test func filterExactPrefix() {
           let result = useCase.execute(cities: cities, filterBy: "B")
           let expected = ["Buenos Aires", "Bahía Blanca"]
           let resultNames = result.map { $0.name }

           #expect(resultNames == expected)
       }

       @Test func filterSingleCity() {
           let result = useCase.execute(cities: cities, filterBy: "Bue")

           #expect(result.count == 1)
           #expect(result.first?.name == "Buenos Aires")
       }

       @Test func filterCaseInsensitive() {
           let result = useCase.execute(cities: cities, filterBy: "S")
           let resultNames = result.map { $0.name }
           let expected = ["Salta", "Suarez", "Santiago del Estero", "Santiago"]

           #expect(resultNames == expected)
       }
        
        @Test func filterCaseInsensitiveFailure() {
            let result = useCase.execute(cities: cities, filterBy: "s")
            #expect(result.isEmpty)
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
    
    //MARK: ValidateCityUseCity
    struct ValidateCityUseCityTest {
        let useCase: ValidateCityUseCaseProtocol
        
        init() {
            useCase = ValidateCityUseCase()
        }
        
        
        @Test(arguments: [CityDetail(title: "Buenos Aires",
                                     countryCode: "AR",
                                     description: "", extract: "",
                                     image: "",
                                     coordinates: .init(latitude: 123, longitude: 123))])
        func validCity(city: CityDetail) {
            let result = useCase.execute(city: city, latitude: 123, longitude: 123)
            #expect(result)
        }
        
        @Test(arguments: [CityDetail(title: "Buenos Aires",
                                     countryCode: "AR",
                                     description: "", extract: "",
                                     image: "",
                                     coordinates: .init(latitude: 123, longitude: 123))])
        func invalidCity(city: CityDetail) {
            let result = useCase.execute(city: city, latitude: 456, longitude: 456)
            #expect(!result)
        }
    }
}
