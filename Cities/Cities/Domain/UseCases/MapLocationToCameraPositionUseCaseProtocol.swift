//
//  MapLocationToCameraPositionUseCaseProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 06/06/2025.
//

protocol MapLocationToCameraPositionUseCaseProtocol {
    func execute(_ location: CityLocation) -> CameraPositionInMap
}
