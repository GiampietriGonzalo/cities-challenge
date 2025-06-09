//
//  CityListViewCoordinatorViewModelMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//


import SwiftUI

final class CityListViewCoordinatorViewModelMock: AppCoordinatorViewModelProtocol {
    
    var navigationPath: NavigationPath = .init()
    var navigationPathBinding: Binding<NavigationPath> = .constant(.init())
    
    var didPushList: Bool = false
    var didPushDetail: Bool = false
    var didPushMap: Bool = false
    var didPop: Bool = false
    var didPopToRoot: Bool = false
    
    func push(_ item: CityListPushNavigationType) {
        switch item {
        case .list:
            didPushList = true
        case .detail(_):
            didPushDetail = true
        case .map(_):
            didPushMap = true
        }
    }
    
    func pop() {
        didPop = true
    }
    
    func popToRoot() {
        didPopToRoot = true
    }
    
    func build(for item: CityListPushNavigationType) -> some View {
        VStack {
            Text("Mock")
        }
    }
}
