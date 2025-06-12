//
//  CityLocationMapperProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import Combine

protocol CityLocationMapperProtocol {
    func map(from cityLocation: CityLocation, actionPublisher: PassthroughSubject<CityListAction, Never>) -> CityLocationViewData
}
