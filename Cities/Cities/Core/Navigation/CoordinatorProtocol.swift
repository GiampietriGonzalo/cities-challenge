//
//  CoordinatorProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI

/**
 Manages and coordinates navigations
 */
protocol CoordinatorProtocol {
    associatedtype NavigationType = NavigationTypeProtocol
}

/**
 Manages and coordinates  Push navigations in a Stack
 - Requires a PushNavigationType
 */
protocol PushCoordinatorProtocol: CoordinatorProtocol where NavigationType: PushNavigationType {
    func push(_ item: NavigationType)
    func pop()
    func popToRoot()
}
