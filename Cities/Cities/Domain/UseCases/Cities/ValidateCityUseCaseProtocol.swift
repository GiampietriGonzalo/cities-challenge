//
//  ValidateCityUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 13/06/2025.
//

protocol ValidateCityUseCaseProtocol {
    
    /**
     * Compare a city coordinates in order to validate if it is the same location due that diferrents city can have the same name
     */
    func execute(city: CityDetail, latitude: Double, longitude: Double) -> Bool
}
