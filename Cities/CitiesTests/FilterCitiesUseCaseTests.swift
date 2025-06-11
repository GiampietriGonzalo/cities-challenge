//
//  FilterCitiesUseCaseTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 08/06/2025.
//

import Testing
@testable import Cities

 struct FilterCitiesUseCaseTests {

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

