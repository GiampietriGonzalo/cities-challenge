//
//  CoordinatorTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 16/06/2025.
//

import Testing
@testable import Cities


struct CoordinatorTests {

    let coordinatorViewModel: AppCoordinatorViewModel
    
    init() {
        coordinatorViewModel = AppCoordinatorViewModel()
    }
    
    @Test func testPushNavigation() async throws {
        coordinatorViewModel.push(.detail(cityName: "", countryCode: "", latitude: 0, longitude: 0))
        #expect(coordinatorViewModel.navigationPath.count == 1)
    }
    
    @Test func testPopNavigation() async throws {
        coordinatorViewModel.push(.detail(cityName: "", countryCode: "", latitude: 0, longitude: 0))
        coordinatorViewModel.pop()
        #expect(coordinatorViewModel.navigationPath.isEmpty)
    }
    
    @Test func testPopToRootNavigation() async throws {
        coordinatorViewModel.push(.detail(cityName: "", countryCode: "", latitude: 0, longitude: 0))
        coordinatorViewModel.push(.detail(cityName: "", countryCode: "", latitude: 0, longitude: 0))
        #expect(coordinatorViewModel.navigationPath.count == 2)
        coordinatorViewModel.popToRoot()
        #expect(coordinatorViewModel.navigationPath.isEmpty)
    }

}
