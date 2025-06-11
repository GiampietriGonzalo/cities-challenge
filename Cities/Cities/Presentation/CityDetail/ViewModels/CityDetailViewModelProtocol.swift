//
//  CityDetailViewModelProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

protocol CityDetailViewModelProtocol {
    
    /**
     *  A CityDetailState  that represents the current state of the screen
     */
    var state: CityDetailState { get }
    
    /**
     *  Start loading asynchronously all the information necessary for the CityDetail screen
     */
    func load() async
}
