//
//  MapperTests.swift
//  CitiesTests
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import Testing
@testable import Cities

struct MapperTests {
    
    //MARK: LocationMapper
    struct LocationMapperTests {
        let mapper: LocationMapperProtocol
        
        init() {
            mapper = LocationMapper()
        }
        
        @Test
        func mapLocationToCameraPosition() {
            let cityLocation = CityLocation.mock
            let result = mapper.map(cityLocation)
            
            guard let region = result.region else {
                #expect(Bool(false))
                return
            }
            
            #expect(region.center.latitude == cityLocation.coordinate.latitude)
            #expect(region.center.longitude == cityLocation.coordinate.longitude)
        }
    }
}
