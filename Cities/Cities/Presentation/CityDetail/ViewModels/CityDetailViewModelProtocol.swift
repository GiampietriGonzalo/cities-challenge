//
//  CityDetailViewModelProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

protocol CityDetailViewModelProtocol {
    var state: CityDetailState { get }
    func load() async
}
