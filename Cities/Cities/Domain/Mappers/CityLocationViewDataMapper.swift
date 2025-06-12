//
//  CityLocationViewDataMapper.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import Combine

struct CityLocationViewDataMapper: CityLocationMapperProtocol {
    func map(from cityLocation: CityLocation, actionPublisher: PassthroughSubject<CityListAction, Never>) -> CityLocationViewData {
        let title = cityLocation.name + ", " + cityLocation.country
        let subtitle = "lat: " + cityLocation.coordinate.latitude.description + ", lon: " + cityLocation.coordinate.longitude.description
        let buttonText = "Details"
        
        return CityLocationViewData(id: cityLocation.id,
                                    title: title,
                                    subtitle: subtitle,
                                    detailButtonText: buttonText,
                                    actionsPublisher: actionPublisher)
    }
}
