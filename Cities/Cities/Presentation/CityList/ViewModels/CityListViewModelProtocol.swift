//
//  CityListViewModelProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

protocol CityListViewModelProtocol {
    
    /**
     *  A CityListViewState  that represents the current state of the screen
     */
    var state: CityListViewState { get }
    
    /**
     *  Start loading asynchronously all the information necessary for the CityList screen
     */
    func load() async
}
