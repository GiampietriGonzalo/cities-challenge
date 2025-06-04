//
//  CityListCoordinatorView.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI

/**
 Coordinator View associated to the City List screen.
 - Requires a ViewModel of type CityListViewCoordinatorViewModelProtocol
 */
struct CityListCoordinatorView<ViewModel: CityListViewCoordinatorViewModelProtocol>: View {
    var viewModel: ViewModel
    var body: some View {
        NavigationStack(path: viewModel.navigationPathBinding) {
            viewModel.build(for: CityListPushNavigationType.list)
                .navigationDestination(for: CityListPushNavigationType.self) { item in
                    viewModel.build(for: item)
                }
        }
    }
}

#Preview {
    CityListCoordinatorView(viewModel: AppContainer.shared.coordinator)
}
