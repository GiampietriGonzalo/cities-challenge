//
//  CityListViewCoordinatorViewModelProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import Observation

/**
 Manages and handles the navigation state for the Characters scene
 - Requires a NavigationPath
 */
protocol CityListViewCoordinatorViewModelProtocol: PushCoordinatorProtocol where NavigationType == CityListPushNavigationType {
    associatedtype SomeView: View
    
    var navigationPath: NavigationPath { get }
    var navigationPathBinding: Binding<NavigationPath> { get }
   
    /**
     Builds the View associated to the navigation item type
     - parameter item: A NavigationType that determinates what View should be build
     */
    @ViewBuilder func build(for item: NavigationType) -> SomeView
}
