//
//  ValidateCityUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 13/06/2025.
//

final class ValidateCityUseCase: ValidateCityUseCaseProtocol {
    func execute(city: CityDetail, latitude: Double, longitude: Double) -> Bool {
        let cityLatitude = city.coordinates.latitude
        let cityLongitude = city.coordinates.longitude
        let latitudeIsValid = abs(latitude - cityLatitude) <= 1
        let longitudeIsValid = abs(longitude - cityLongitude) <= 1
        
        return latitudeIsValid && longitudeIsValid
    }
}
