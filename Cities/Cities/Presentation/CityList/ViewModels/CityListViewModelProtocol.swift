//
//  CityListViewModelProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

protocol CityListViewModelProtocol {
    var state: CityListViewState { get }
    func load() async
}
