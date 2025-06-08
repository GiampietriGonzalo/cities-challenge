//
//  FilterCitiesUseCaseTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 08/06/2025.
//

import Testing
@testable import Cities

 struct TrieFilterCitiesUseCaseTests {

    private let cities: [CityLocation] = [
        CityLocation(id: 1, name: "Alabama", country: "US", coordinate: .init(latitude: 0, longitude: 0)),
        CityLocation(id: 2, name: "Albuquerque", country: "US", coordinate: .init(latitude: 0, longitude: 0)),
        CityLocation(id: 3, name: "Anaheim", country: "US", coordinate: .init(latitude: 0, longitude: 0)),
        CityLocation(id: 4, name: "Arizona", country: "US", coordinate: .init(latitude: 0, longitude: 0)),
        CityLocation(id: 5, name: "Sydney", country: "AU", coordinate: .init(latitude: 0, longitude: 0))
    ]
    
    let useCase: FilterCitiesUseCaseProtocol
    
    init() {
        useCase = FilterCitiesUseCase()
    }
    

    @Test func testFilterExactPrefix() {
        let result = useCase.execute(cities: cities, filterBy: "Al")

        let expected = ["Alabama", "Albuquerque"]
        let resultNames = result.map { $0.name }

        #expect(resultNames == expected)
    }

    @Test func testFilterSingleCity() {
        let result = useCase.execute(cities: cities, filterBy: "Alb")

        #expect(result.count == 1)
        #expect(result.first?.name == "Albuquerque")
    }

    @Test func testFilterCaseInsensitive() {
        let result = useCase.execute(cities: cities, filterBy: "a")

        let resultNames = result.map { $0.name }
        let expected = ["Alabama", "Albuquerque", "Anaheim", "Arizona"]

        #expect(resultNames == expected)
    }

    @Test func testFilterNoMatch() {
        let result = useCase.execute(cities: cities, filterBy: "xyz")

        #expect(result.isEmpty)
    }

    @Test func testEmptyPrefixReturnsAll() {
        let result = useCase.execute(cities: cities, filterBy: "")

        #expect(result.count == cities.count)
    }
}

