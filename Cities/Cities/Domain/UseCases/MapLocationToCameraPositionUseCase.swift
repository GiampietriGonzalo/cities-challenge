//
//  MapLocationToCameraPositionUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 06/06/2025.
//

final class MapLocationToCameraPositionUseCase: MapLocationToCameraPositionUseCaseProtocol {
    func execute(_ location: CityLocation) -> CameraPositionInMap {
        CameraPositionInMap(center: .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                            distance: .init(latitude: 50000, longitude: 50000))
    }
}
