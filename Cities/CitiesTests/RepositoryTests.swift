//
//  RepositoryTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import Testing
import SwiftData
import Foundation
@testable import Cities

struct RepositoryTests {
    
    struct CityRepositoryTests {
        let networkClient: NetworkClientMock
        let repository: CityRepositoryProtocol
        
        init() {
            networkClient = NetworkClientMock()
            repository = CityRepository(networkClient: networkClient)
        }
        
        @Test(arguments: [[CityLocationDTO.mock, CityLocationDTO.mock],
                          [CityLocationDTO.mock],
                          []])
        func testFetchCityLocationsSuccess(dtos: [CityLocationDTO]) async throws {
            networkClient.dto = dtos
            let result = try await repository.fetchCitiesLocation()
            
            #expect(result.count == dtos.count)
            
            for dto in result {
                #expect(dtos.contains(where: { $0._id == dto._id }))
            }
        }
        
        @Test(arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error")])
        func testLoadFailure(customError: CustomError) async {
            networkClient.customError = customError
            
            do {
                _ = try await repository.fetchCitiesLocation()
            } catch {
                #expect(error == customError)
            }
        }
        
        @Test(arguments: [CityDetailDTO.mock])
        func testFetchCityDetailsSuccess(dto: CityDetailDTO) async throws {
            let name = dto.title
            networkClient.dto = dto
            
            do {
                let result = try await repository.fetchCityDetail(nameParam: name)
                #expect(result.title == dto.title)
                #expect(result.description == dto.description)
                #expect(result.extract == dto.extract)
            } catch {
                #expect(Bool(false))
            }
        }
        
        @Test(arguments: [CustomError.invalidUrl("invalid url"),
                          CustomError.serviceError("service error"),
                          CustomError.decodeError("decode error")])
        func testFetchCityDetailsFailure(customError: CustomError) async {
            networkClient.customError = customError
            do {
                _ = try await repository.fetchCityDetail(nameParam: "Buenos Aires")
                #expect(Bool(false))
            } catch {
                #expect(error == customError)
            }
        }
        
        @Test
        func testFetchCityDetailsFailureWithEmptyName() async {
            networkClient.dto = CityDetailDTO.mock
            do {
                _ = try await repository.fetchCityDetail(nameParam: "")
                #expect(Bool(false))
            } catch {
                #expect(error == .serviceError("City name is empty"))
            }
        }
    }
    
    struct FavoriteRepositoryTest {
        @Suite class FavoriteRepositoryTests {
            private var container: ModelContainer
            private var context: ModelContext
            private var repository: FavoriteRepository

            init() throws {
                container = try ModelContainer(for: FavoriteCity.self)
                context = ModelContext(container)
                repository = FavoriteRepository(modelContext: context)
            }
            
            @Test(arguments: [123, 456, 789])
            func testInsertFavoriteSucces(id: Int) throws {
                try repository.insertFavorite(cityId: id)

                let predicate = #Predicate<FavoriteCity> { $0.id == id }
                let request = FetchDescriptor<FavoriteCity>(predicate: predicate)
                let result = try context.fetch(request)

                #expect(result.count == 1)
                #expect(result.first?.isFavorite == true)
            }

            @Test func testInsertItemDoesNotDuplicate() throws {
                let id = 12345
                try repository.insertFavorite(cityId: id)
                try repository.insertFavorite(cityId: id)

                let request = FetchDescriptor<FavoriteCity>(predicate: #Predicate { $0.id == id })
                let result = try context.fetch(request)

                #expect(result.count == 1)
            }

            @Test func testFailureWhenContextIsNil() {
                let repository = FavoriteRepository(modelContext: nil)

                do {
                    _ = try repository.fetchFavorites()
                    #expect(Bool(false))
                } catch {
                    #expect(error == CustomError.serviceError("Context not available"))
                }
            }
        }
    }
}
